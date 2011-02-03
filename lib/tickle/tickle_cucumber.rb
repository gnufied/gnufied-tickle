module Tickle
  class CucumberRunner
    include AbstractAdapter
    def run(n = 2)
      redirect_stdout()
      load_environment('cucumber')
      pids = []
      n.times do |index|
        pids << Process.fork do
          prepare_databse(index) unless try_migration_first(index)
          r = Redis.new(:host => Tickle::Config.redis_ip,:port => Tickle::Config.redis_port)
          while (filename = r.rpop('cucumber'))
            args = %w(--format progress) + Array(filename)
            failure = Cucumber::Cli::Main.execute(args)
            raise "Cucumber failed" if failure
          end
        end
      end

      Signal.trap 'SIGINT', lambda { pids.each { |p| Process.kill("KILL", p) }; exit 1 }
      errors = Process.waitall.map { |pid, status| status.exitstatus }
      raise "Error running test" if (errors.any? { |x| x != 0 })
    end

    def add_to_redis
      feature_files = Dir["#{Rails.root}/features/**/*.feature"]
      redis = Redis.new(:host => Tickle::Config.redis_ip,:port => Tickle::Config.redis_port)
      redis.del 'cucumber'
      feature_files.each { |x| redis.rpush('cucumber', x) }
    end
    
  end
end