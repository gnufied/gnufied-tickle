module Tickle
  class Server < EM::Connection
    include EM::P::ObjectProtocol
    @@workers = {}
    @@requester = {}

    @@status_count = 0
    @@status_reports = []
    
    def receive_object(ruby_object)

      case ruby_object
      when StartBuild
        start_build
      when BuildOutput
        send_to_requester(ruby_object)
      when BuildStatus
         puts "Received object #{ruby_object.inspect}"
        collect_status_response(ruby_object)
      when WorkerConnected
        @@workers[self.signature] = self
      when BuildRequester
        @@requester[self.signature] = self
      end
    end

    def collect_status_response(ruby_object)

      @@status_reports << ruby_object
      @@status_count -= 1
      puts "Status count is #{@@status_count}"
      if(@@status_count == 0)
        error_status = @@status_reports.any? {|x| x.exit_status != 0 }
        @@status_reports = []
        if(error_status)
          send_to_requester(BuildStatus.new(-1))
        else
          send_to_requester(BuildStatus.new(0))
        end
      end
    end

    def unbind
      @@workers.delete(self.signature)
      @@requester.delete(self.signature)
    end

    def start_build
      @@workers.each do |key,worker|
        @@status_count += 2
        worker.send_object(StartBuild.new())
        worker.send_object(StartTest.new())
        worker.send_object(StartCucumber.new())
      end
    end

    def send_to_requester(ruby_object)
      @@requester.each do |key,requester|
        requester.send_object(ruby_object)
      end
    end
  end
end
