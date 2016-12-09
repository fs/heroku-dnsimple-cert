require "thor"

module HerokuDnsimpleCert
  class CLI < Thor
    desc "update", "Create or update Heroku certificate from DNSimple"
    def update
      puts HerokuDnsimpleCert.create_or_update
    end
  end
end
