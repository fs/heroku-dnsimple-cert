require "spec_helper"

describe HerokuDnsimpleCert::HerokuCertificate do
  let(:sni_endpoint) { instance_double(PlatformAPI::SniEndpoint) }
  let(:client) { instance_double(PlatformAPI::Client) }

  let(:app) { "heroku-app" }
  let(:token) { "token" }
  let(:certificate_chain) { "certificate_chain" }
  let(:private_key) { "private_key" }

  let(:certificate) do
    described_class.new(
      token: token, app: app,
      certificate_chain: certificate_chain, private_key: private_key,
      client: client
    )
  end

  before do
    allow(client).to receive(:sni_endpoint) { sni_endpoint }
  end

  describe "#create" do
    before do
      allow(sni_endpoint).to receive(:list) { [] }
    end

    it "creates new certificate" do
      expect(sni_endpoint).to receive(:create)
        .with(app, certificate_chain: certificate_chain, private_key: private_key)

      certificate.create
    end
  end

  describe "#create" do
    let(:certificate_name) { "maiasaura-93199" }

    before do
      allow(sni_endpoint).to receive(:list) { [{ "name" => certificate_name }] }
    end

    it "updates certificate" do
      expect(sni_endpoint).to receive(:update)
        .with(app, certificate_name, certificate_chain: certificate_chain, private_key: private_key)

      certificate.update
    end
  end
end
