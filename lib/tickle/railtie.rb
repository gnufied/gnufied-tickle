require 'tickle/tickle_runner'
require 'rails'

puts "requiring this file"
module Tickle
  class Railtie < Rails::Railtie
    railtie_name :tickle
    rake_tasks do
      puts "******* Running tasks tasks block"
      require 'tickle_tasks.rake'
    end
  end
end
