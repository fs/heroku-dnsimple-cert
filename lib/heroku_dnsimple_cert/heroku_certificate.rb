require "platform-api"

module HerokuDnsimpleCert
  class HerokuCertificate
    attr_reader :client, :app, :certificate_chain, :private_key

    def initialize(token:, app:, certificate_chain:, private_key:, client: nil)
      @client = client || PlatformAPI.connect_oauth(token)
      @certificate_chain = certificate_chain
      @private_key = private_key
      @app = app
    end

    def certificates
      @certificates ||= client.sni_endpoint.list(app)
    end

    def update
      client.sni_endpoint.update(app, certificates[0]["name"], create_or_update_options)
    end

    def create
      client.sni_endpoint.create(app, create_or_update_options)
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
