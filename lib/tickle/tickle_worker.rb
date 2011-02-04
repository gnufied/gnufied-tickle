module Tickle
  class Worker < EM::Connection
    include EM::P::ObjectProtocol
    @@status_reports = []
    
    def receive_object(ruby_object)
      case ruby_object
      when StartBuild
        update_code
      when StartTest
        start_test
      end
    end

    def connection_completed
      send_object(WorkerConnected.new(self.signature))
    end

    def unbind
      EM.add_timer(3) {
        reconnect(Tickle::Config.ip,Tickle::Config.port)
      }
    end

    def update_code
      start_test
#      source_control = Tickle::Git.new()
#      source_control.update()
#      if (source_control.status)
#        start_test
#      else
#        send_object(BuildStatus.new(1))
#      end
    end

    def start_test
      EM.popen("rake tickle:test RAILS_ENV=test", TestRunner) do |process|
        process.worker = self
        process.runner_type = 'unit'
      end
    end

    def start_cucumber(last_status)
      @@status_reports << last_status
      EM.popen("rake tickle:cucumber RAILS_ENV=cucumber",TestRunner) do |process|
        process.worker = self
        process.runner_type = 'cucumber'
      end
    end

    def send_final_report(last_status)
      @@status_reports << last_status
      error_flag = @@status_reports.any? {|x| x.exit_status != 0}
      
      if(error_flag)
        send_object(BuildStatus.new(1))
      else
        send_object(BuildStatus.new(0))
      end
    end
  end

  class TestRunner < EM::Connection
    attr_accessor :worker
    attr_accessor :runner_type
    
    include EM::P::ObjectProtocol
    def receive_data(data)
      worker.send_object(BuildOutput.new(data))
    end

    def unbind
      puts "Sending the status thingy"
      if(runner_type == 'unit')
        worker.start_cucumber(BuildStatus.new(get_status.exitstatus))
      else
        worker.send_final_report(BuildStatus.new(get_status.exitstatus))
      end
    end
  end
end
