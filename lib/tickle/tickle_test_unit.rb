module Tickle
  class TestUnit
    include AbstractAdapter
    
    def run(size = 2)
      redirect_stdout()
      load_environment('test')
      pids = []
      size.times do |index|
        pids << Process.fork do
          prepare_databse(index) unless try_migration_first(index)
          r = Redis.new(:host => Tickle::Config.redis_ip,:port => Tickle::Config.redis_port)
          while (filename = r.rpop('tests'))
            unless filename =~ /^-/
              full_filename = Rails.root.to_s + filename
              load(full_filename) 
            end
          end
        end
      end
      Signal.trap 'SIGINT', lambda { pids.each { |p| Process.kill("KILL", p) }; exit 1 }

      errors = Process.waitall.map { |pid, status| status.exitstatus }
      raise "Error running test" if (errors.any? { |x| x != 0 })
    end

    def add_to_redis
      test_files = (Dir["#{Rails.root}/test/unit/**/**_test.rb"] + Dir["#{Rails.root}/test/functional/**/**_test.rb"]).map do |fl|
        fl.gsub(/#{Rails.root}/,'')
      end

      redis = Redis.new(:host => Tickle::Config.redis_ip,:port => Tickle::Config.redis_port)
      redis.del 'tests'
      test_files.each { |x| redis.rpush('tests', x) }
    end
  end
end
