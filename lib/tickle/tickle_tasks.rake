
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
  
  desc "Request server to run test"
  task :build do
    Tickle::TestUnit.new().add_to_redis
    Tickle::CucumberRunner.new().add_to_redis
    EM.run {
      Tickle::Requestor.make_request
    }
  end

  desc "Start server"
  task :start_server do
    EM.run {
      EM.start_server(Tickle::Config.ip,Tickle::Config.port,Tickle::Server)
    }
  end

  desc "Start Client"
  task :start_client do
    EM.run {
      EM.connect(Tickle::Config.ip,Tickle::Config.port,Tickle::Worker)
    }
  end

  
  desc "Run redis tests"
  task :redis_test, :count do |t,args|
    Tickle.load_environment('test')
    size = args[:count] ? args[:count].to_i : 3
    puts "Running tests using #{size} processes"
    Tickle.run_redis_test(size)
  end
  
  desc "Run cucumber parallel test"
  task :cucumber, :count do |t,args|
    Tickle.load_environment('cucumber')
    size = args[:count] ? args[:count].to_i : 3
    puts "Running Cucumber tests using #{size} processes"
    puts "Using the default profile..."
    Tickle.run_cucumber(size)
  end
end
