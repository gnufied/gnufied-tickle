module Tickle
  class Server
    include EM::P::ObjectProtocol
    def receive_object(ruby_object)
      case ruby_object
      when StartBuild
        start_build
      when BuildOutput
        send_to_requester(ruby_object)
      when BuildStatus
        send_to_requester(ruby_object)
      when WorkerConnected
        @workers ||= {}
        @workers[ruby_object.name] = self
      when BuildRequester
        @requester ||= {}
        @requester[ruby_object.name] = self
      end
    end

    def start_build
      @workers.each do |key,worker|
        worker.send_object(StartBuild.new())
        worker.send_object(StartTest.new())
        worker.send_object(StartCucumber.new())
      end
    end

    def send_to_requester(ruby_object)
      @requester.each do |key,requester|
        requester.send_object(ruby_object)
      end
    end
  end
end
