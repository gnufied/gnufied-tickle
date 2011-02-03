module Tickle
  class Requestor < EM::Connection
    include EM::P::ObjectProtocol
    def self.make_request
      EM.connect(Tickle::Config.ip,Tickle::Config.port,Requestor)
    end

    def connection_completed
      send_object(BuildRequester.new())
      send_object(StartBuild.new())
    end

    def receive_object(ruby_object)
      case ruby_object
      when BuildOutput
        print ruby_object.data
      when BuildStatus
        stop_build(ruby_object)
      end
    end

    def stop_build(ruby_object)
      if(ruby_object.exit_status == 0)
        puts "Successfully ran all tests"
        EM.stop()
      else
        abort("Error running tests")
      end
    end
    
  end
end
