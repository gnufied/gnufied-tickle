# Generated by jeweler
# DO NOT EDIT THIS FILE DIRECTLY
# Instead, edit Jeweler::Tasks in Rakefile, and run 'rake gemspec'
# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{tickle}
  s.version = "0.0.4"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Hemant Kumar"]
  s.date = %q{2011-02-04}
  s.description = %q{Run your tests parallely}
  s.email = %q{hkumar@crri.co.in}
  s.extra_rdoc_files = [
    "LICENSE.txt",
    "README.rdoc"
  ]
  s.files = [
    ".document",
    "Gemfile",
    "Gemfile.lock",
    "LICENSE.txt",
    "README.rdoc",
    "Rakefile",
    "VERSION",
    "lib/tickle.rb",
    "lib/tickle/railtie.rb",
    "lib/tickle/tickle_abstract_adapter.rb",
    "lib/tickle/tickle_config.rb",
    "lib/tickle/tickle_cucumber.rb",
    "lib/tickle/tickle_git.rb",
    "lib/tickle/tickle_messages.rb",
    "lib/tickle/tickle_requestor.rb",
    "lib/tickle/tickle_runner.rb",
    "lib/tickle/tickle_server.rb",
    "lib/tickle/tickle_tasks.rake",
    "lib/tickle/tickle_test_unit.rb",
    "lib/tickle/tickle_worker.rb",
    "test/helper.rb",
    "test/test_tickle.rb",
    "tickle.gemspec"
  ]
  s.homepage = %q{http://github.com/gnufied/tickle}
  s.licenses = ["MIT"]
  s.require_paths = ["lib"]
  s.rubygems_version = %q{1.4.1}
  s.summary = %q{Run your tests parallely}
  s.test_files = [
    "test/helper.rb",
    "test/test_tickle.rb"
  ]

  if s.respond_to? :specification_version then
    s.specification_version = 3

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<eventmachine>, [">= 0"])
      s.add_runtime_dependency(%q<redis>, [">= 0"])
      s.add_development_dependency(%q<bundler>, ["~> 1.0.0"])
      s.add_development_dependency(%q<jeweler>, ["~> 1.5.2"])
    else
      s.add_dependency(%q<eventmachine>, [">= 0"])
      s.add_dependency(%q<redis>, [">= 0"])
      s.add_dependency(%q<bundler>, ["~> 1.0.0"])
      s.add_dependency(%q<jeweler>, ["~> 1.5.2"])
    end
  else
    s.add_dependency(%q<eventmachine>, [">= 0"])
    s.add_dependency(%q<redis>, [">= 0"])
    s.add_dependency(%q<bundler>, ["~> 1.0.0"])
    s.add_dependency(%q<jeweler>, ["~> 1.5.2"])
  end
end

