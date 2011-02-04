module Tickle
  class CucumberRunner
    include AbstractAdapter
    def run(n = 2)
      redirect_stdout()
      load_environment('cucumber')
      all_status = []

      r = Redis.new(:host => Tickle::Config.redis_ip,:port => Tickle::Config.redis_port)

      redis_has_files = true

      loop do
        local_pids = []
        
        n.times do
          feature_files = r.rpop('cucumber')
          
          if(feature_files)
            local_pids << Process.fork do
              prepare_databse(index) unless try_migration_first(index)
              args = %w(--format progress) + feature_files
              failure = Cucumber::Cli::Main.execute(args)
              raise "Cucumber failed" if failure
            end
          else
            redis_has_files = false
            break
          end
        end #end of n#times

        Signal.trap 'SIGINT', lambda { local_pids.each { |p| Process.kill("KILL", p) }; exit 1 }
        
        all_status += Process.waitall.map { |pid, status| status.exitstatus }
        
        break unless redis_has_files
      end # end of loop
      
      raise "Error running cucumber tests" if (all_status.any? { |x| x != 0 })
    end

    def feature_files(files)
      make_command_line_safe(FileList[ files || [] ])
    end

    def make_command_line_safe(list)
      list.map{|string| string.gsub(' ', '\ ')}
    end

    def add_to_redis(worker_count)
      feature_files = Dir["#{Rails.root}/features/**/*.feature"].sort.in_groups(n, false)
      redis = Redis.new(:host => Tickle::Config.redis_ip,:port => Tickle::Config.redis_port)
      redis.del 'cucumber'
      feature_files.each { |x| redis.rpush('cucumber', x) }
    end
    
  end
end
