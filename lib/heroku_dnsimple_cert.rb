require "rubygems"
require "bundler/setup"
require "dotenv"
require "byebug"

require "heroku_dnsimple_cert/cli"
require "heroku_dnsimple_cert/dnsimple_certificate"
require "heroku_dnsimple_cert/heroku_certificate"

Dotenv.load

module HerokuDnsimpleCert
  def self.create_or_update
    heroku_certificate.create_or_update
  end

  def self.dnsimple_certificate
    @dnsimple_certificate ||= DnsimpleCertificate.new(
      token: ENV.fetch("DNSIMPLE_TOKEN"),
      account_id: ENV.fetch("DNSIMPLE_ACCOUNT_ID"),
      domain: ENV.fetch("DNSIMPLE_DOMAIN"),
      common_name:  ENV.fetch("DNSIMPLE_COMMON_NAME")
    )
  end

  def self.heroku_certificate
    @heroku_certificate ||= HerokuCertificate.new(
      token: ENV.fetch("HEROKU_TOKEN"),
      app: ENV.fetch("HEROKU_APP"),
      certificate_chain: dnsimple_certificate.certificate_chain,
      private_key: dnsimple_certificate.private_key
    )
  end
end
