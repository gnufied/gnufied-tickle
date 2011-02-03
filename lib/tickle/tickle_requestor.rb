module Tickle
  class Requestor
    include EM::P::ObjectProtocol
    def self.make_request
      EM.connect(Tickle::Config.ip,Tickle::Config.port,Requestor)
    end

    def connection_completed
      send_object(StartBuild.new())
    end

    def receive_object(ruby_object)
      case ruby_object
      when BuildOutput
        puts ruby_object.data
      when BuildStatus
        stop_build()
      end
    end

    def stop_build(ruby_object)
      if(ruby_object.status)
        EM.stop_reactor()
      else
        abort("Error running tests")
      end
    end
    
  end
end