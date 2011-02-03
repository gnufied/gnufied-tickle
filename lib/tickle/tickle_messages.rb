module Tickle
  class StartBuild
  end

  class StartTest
  end

  class StartCucumber
  end

  class BuildOutput
    attr_accessor :data
    def initialize(data); @data = data; end
  end

  class WorkerConnected
    attr_accessor :name
    def initialize(name); @name = name; end
  end

  class BuildRequester; end

  class BuildStatus
    attr_accessor :exit_status
    def initialize(exit_status)
      @exit_status = exit_status
    end
  end
end
