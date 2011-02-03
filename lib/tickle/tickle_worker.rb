module Tickle
  class Worker
    include EM::P::ObjectProtocol
    def receive_object(ruby_object)
      case ruby_object
      when StartBuild
        update_code()
      when StartTest
        start_test
      when StartCucumber
        start_cucumber
      end
    end

    def update_code
      source_control = Tickle::Git.new()
      revision = source_control.latest_revision
      source_control.update(revision)
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

  class TestRunner
    attr_accessor :worker
    include EM::P::ObjectProtocol
    def receive_data(data)
      worker.send_object(data)
    end
  end
end
