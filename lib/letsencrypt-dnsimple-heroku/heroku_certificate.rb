require "platform-api"

class HerokuCertificate
  attr_reader :client, :app, :certificate_chain, :private_key

  def initialize(token:, app:, certificate_chain:, private_key:)
    @client = PlatformAPI.connect_oauth(token)

    @certificate_chain = certificate_chain
    @private_key = private_key
    @app = app
  end

  def create_or_update
    if certificates.any?
      print "Updating existing certificate #{certificates[0]['name']}..."
      update_crt
    else
      print "Adding new certificate..."
      create_crt
    end

    puts "Done!"
  rescue Excon::Error::UnprocessableEntity => e
    warn "Error adding certificate to Heroku. Response from Heroku’s API follows:"
    abort e.response.body
  end

  private

  def update
    client.sni_endpoint.update(app, certificates[0]["name"], create_or_update_options)
  end

  def create
    client.sni_endpoint.create(app, create_or_update_options)
  end

  def create_or_update_options
    {
      certificate_chain: certificate_chain,
      private_key: private_key
    }
  end

  def certificates
    @certificates ||= client.sni_endpoint.list(app)
  end
end
