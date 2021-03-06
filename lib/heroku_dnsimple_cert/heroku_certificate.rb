module HerokuDnsimpleCert
  class HerokuCertificate
    attr_reader :client, :app, :certificate_chain, :private_key

    def initialize(token:, app:, certificate_chain:, private_key:, client: nil)
      @client = client || HerokuSni.new(token, app)
      @certificate_chain = certificate_chain
      @private_key = private_key
      @app = app
    end

    def certificates
      @certificates ||= client.list
    end

    def update
      client.update(certificates[0]["name"], create_or_update_options)
    end

    def create
      client.create(create_or_update_options)
    end

    private

    def create_or_update_options
      {
        certificate_chain: certificate_chain,
        private_key: private_key
      }
    end
  end
end
