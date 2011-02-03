require File.join(File.dirname(__FILE__),'tickle_runner')
require 'rails'
require "eventmachine"
require "redis"
require File.join(File.dirname(__FILE__),'tickle_abstract_adapter')
require File.join(File.dirname(__FILE__),'tickle_config')
require File.join(File.dirname(__FILE__),'tickle_cucumber')
require File.join(File.dirname(__FILE__),'tickle_git')
require File.join(File.dirname(__FILE__),'tickle_messages')

require File.join(File.dirname(__FILE__),'tickle_requestor')
require File.join(File.dirname(__FILE__),'tickle_runner')
require File.join(File.dirname(__FILE__),'tickle_server')

require File.join(File.dirname(__FILE__),'tickle_test_unit')
require File.join(File.dirname(__FILE__),'tickle_worker')


module Tickle
  class Railtie < Rails::Railtie
    rake_tasks do
      load File.join(File.dirname(__FILE__),'tickle_tasks.rake')
    end
  end
end
