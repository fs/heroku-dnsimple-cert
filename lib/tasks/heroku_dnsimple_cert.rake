require "dotenv/tasks"

namespace :heroku_dnsimple_cert do
  desc "Create or update Heroku certificate from DNSimple"
  task update: :dotenv do
    HerokuDnsimpleCert::CLI.new.invoke(:update)
  end
end
