# Yanked from Rails
desc 'Run all unit, functional and integration tests'
task :tickle, :count do |t, args|
  errors = %w(tickle:units tickle:functionals).collect do |task|
    begin
      Rake::Task[task].invoke(args[:count])
      nil
    rescue => e
      puts e
      puts e.backtrace
      task
    end
  end.compact
  abort "Errors running #{errors.to_sentence}!" if errors.any?
end

namespace :tickle do
  [:unit, :functional].each do |t|
    type = t.to_s.sub(/s$/, '')

    desc "Run #{type} tests"
    task t, :count do |t, args|
      Tickle.load_environment
      size = args[:count] ? args[:count].to_i : 3
      #Tickle.prepare_all_databases(size)
      puts "Running #{type} tests using #{size} processes"
      Tickle.run_tests type, size
    end
  end
  
  desc "Run redis tests"
  task :redis_test, :count do |t,args|
    Tickle.load_environment
    size = args[:count] ? args[:count].to_i : 3
    puts "Running tests using #{size} processes"
    Tickle.run_redis_test(size)
  end
  
  desc "Run cucumber parallel test"
  task :cucumber, :count do |t,args|
    Tickle.load_environment
    size = args[:count] ? args[:count].to_i : 3
    puts "Running Cucumber tests using #{size} processes"
    puts "Using the default profile..."
    Tickle.run_cucumber(size)
  end
end
