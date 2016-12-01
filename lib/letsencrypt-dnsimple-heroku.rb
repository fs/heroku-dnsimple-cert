require "rubygems"
require "bundler/setup"
require "dotenv"

require "dnsimple_certificate"
require "heroku_certificate"

require "byebug"

Dotenv.load

module LetsencryptDnsimpleHeroku
  def self.create_or_update_cert
    heroku_certificate.create_or_update
  end

  def dnsimple_certificate
    @dnsimple_certificate ||= DnsimpleCertificate.new(
      token: ENV.fetch("DNSIMPLE_TOKEN"),
      account_id: ENV.fetch("DNSIMPLE_ACCOUNT_ID"),
      domain: ENV.fetch("DNSIMPLE_DOMAIN"),
      common_name:  ENV.fetch("DNSIMPLE_COMMON_NAME")
    )
  end

  def heroku_certificate
    @heroku_certificate ||= HerokuCertificate.new(
      token: ENV.fetch("HEROKU_TOKEN"),
      app: ENV.fetch("HEROKU_APP"),
      certificate_chain: dnsimple_certificate.certificate_chain,
      private_key: dnsimple_certificate.private_key,
    )
  end
end
