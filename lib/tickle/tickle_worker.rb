module Tickle
  class Worker < EM::Connection
    include EM::P::ObjectProtocol
    def receive_object(ruby_object)
      case ruby_object
      when StartBuild
        update_code
      when StartTest
        start_test
      when StartCucumber
        start_cucumber
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
      source_control = Tickle::Git.new()
      source_control.update()
      if(source_control.status)
        send_object(GitStatus.new(0))
      else
        send_object(GitStatus.new(1))
      end
    end

    def start_test
      EM.popen("rake tickle:test RAILS_ENV=test", TestRunner) do |process|
        process.worker = self
      end
    end

    def start_cucumber
      EM.popen("rake tickle:cucumber RAILS_ENV=cucumber",TestRunner) do |process|
        process.worker = self
      end
    end
  end

  class TestRunner < EM::Connection
    attr_accessor :worker
    include EM::P::ObjectProtocol
    def receive_data(data)
      worker.send_object(BuildOutput.new(data))
    end

    def unbind
      puts "Sending the status thingy"
      worker.send_object(BuildStatus.new(get_status.exitstatus))
    end
  end
end
