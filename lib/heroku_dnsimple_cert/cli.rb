require "thor"
require "tty/spinner"
require "pastel"

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
      task "Fetching certificate chain from DNSimple for #{options['dnsimple_common_name']}" do
        dnsimple_certificate.certificate_chain
      end

      task "Fetching private key from DNSimple for #{options['dnsimple_common_name']}" do
        dnsimple_certificate.private_key
      end

      task "Fetching certificates from Heroku app #{options['heroku_app']}" do
        heroku_certificate.certificates
      end

      if heroku_certificate.certificates.any?
        task "Updating existing certificate on Heroku app #{options['heroku_app']}" do
          heroku_certificate.update
        end
      else
        task "Adding new certificate on Heroku app #{options['heroku_app']}" do
          heroku_certificate.create
        end
      end
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

    def task(name)
      spinner.update name: name
      spinner.auto_spin
      spinner.start
      yield
      spinner.success(pastel.green("OK"))
    rescue => e
      spinner.error(pastel.red(e.to_s))
    end

    def pastel
      @pastel ||= Pastel.new
    end

    def spinner
      @spinner ||= TTY::Spinner.new(
        %([#{pastel.yellow(':spinner')}] :name ...),
        success_mark: pastel.green(TTY::Spinner::TICK),
        error_mark: pastel.red(TTY::Spinner::CROSS)
      )
    end
  end
end
