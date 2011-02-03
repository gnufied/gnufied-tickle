require "fileutils"

module Tickle

  class Git
    attr_accessor :repository
    attr_accessor :path

    def current_branch
      cmd_output = `git symbolic-ref HEAD`
      branch_name = cmd_output.strip.split("/")[-1]
      branch_name
    end

    def update
      FileUtils.cd(Rails.root) do
        system("git reset --hard HEAD")
        system("git fetch & git rebase origin/#{current_branch}")
        system("git submodule init")
        system("git submodule update")
      end
    end
  end
end
