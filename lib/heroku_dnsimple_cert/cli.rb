require "thor"

Dotenv.load

module HerokuDnsimpleCert
  class CLI < Thor
    include Thor::Actions

    OPTIONS = %w(dnsimple_token dnsimple_account_id dnsimple_domain dnsimple_common_name heroku_token heroku_app).freeze

    OPTIONS.each do |option|
      method_option(option, type: :string, default: ENV[option.upcase], required: true)
    end

    desc :update, "Create or update Heroku certificate from DNSimple"

    # rubocop:disable Metrics/AbcSize
    # rubocop:disable Metrics/MethodLength
    def update
      say "Fetching certificate chain from DNSimple for #{options['dnsimple_common_name']} ...", :green
      dnsimple_certificate.certificate_chain

      say "Fetching private key from DNSimple for #{options['dnsimple_common_name']}. ..", :green
      dnsimple_certificate.private_key

      say "Fetching certificates from Heroku app #{options['heroku_app']} ...", :green
      heroku_certificate.certificates

      if heroku_certificate.certificates.any?
        say "Updating existing certificate on Heroku app #{options['heroku_app']} ...", :green
        heroku_certificate.update
      else
        say "Adding new certificate on Heroku app #{options['heroku_app']} ...", :green
        heroku_certificate.create
      end

      say "Done!", :green
    rescue => e
      say "Error adding certificate ...", :red
      say "   Response: #{e}", :red

      abort
    end

    private

    def dnsimple_certificate
      @dnsimple_certificate ||= DnsimpleCertificate.new(
        token: options["dnsimple_token"],
        account_id: options["dnsimple_account_id"],
        domain: options["dnsimple_domain"],
        common_name:  options["dnsimple_common_name"]
      )
    end

    def heroku_certificate
      @heroku_certificate ||= HerokuCertificate.new(
        token: options["heroku_token"],
        app: options["heroku_app"],
        certificate_chain: dnsimple_certificate.certificate_chain,
        private_key: dnsimple_certificate.private_key
      )
    end

    def say(message = "", color = nil)
      color = nil unless $stdout.tty?
      super(message.to_s, color)
    end
  end
end
