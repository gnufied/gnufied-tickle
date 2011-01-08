require File.join(File.dirname(__FILE__),'tickle_runner')
require 'rails'

module Tickle
  class Railtie < Rails::Railtie
    rake_tasks do
      load File.join(File.dirname(__FILE__),'tickle_tasks.rake')
    end
  end
end
