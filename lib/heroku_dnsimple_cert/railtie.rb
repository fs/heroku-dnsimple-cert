module HerokuDnsimpleCert
  class Railtie < Rails::Railtie
    rake_tasks do
      load "tasks/heroku_dnsimple_cert.rake"
    end
  end
end
