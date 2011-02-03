module Tickle
  class TestUnit
    include AbstractAdapter
    
    def run(size = 2)
      pids = []
      size.times do |index|
        pids << Process.fork do
          prepare_databse(index) unless try_migration_first(index)
          r = Redis.new()
          while (filename = r.rpop('tests'))
            load(filename) unless filename =~ /^-/
          end
        end
      end
      Signal.trap 'SIGINT', lambda { pids.each { |p| Process.kill("KILL", p) }; exit 1 }

      errors = Process.waitall.map { |pid, status| status.exitstatus }
      raise "Error running test" if (errors.any? { |x| x != 0 })
    end

    def add_to_redis
      test_files = Dir["#{Rails.root}/test/unit/**/**_test.rb"] + Dir["#{Rails.root}/test/functional/**/**_test.rb"]
      redis = Redis.new()
      redis.del 'tests'
      test_files.each { |x| redis.rpush('tests', x) }
    end
  end
end
