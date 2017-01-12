require "spec_helper"

describe HerokuDnsimpleCert::HerokuCertificate do
  let(:client) { instance_double(HerokuSni) }

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

  describe "#create" do
    before do
      allow(client).to receive(:list) { [] }
    end

    it "creates new certificate" do
      expect(client).to receive(:create)
        .with(certificate_chain: certificate_chain, private_key: private_key)

      certificate.create
    end
  end

  describe "#create" do
    let(:certificate_name) { "maiasaura-93199" }

    before do
      allow(client).to receive(:list) { [{ "name" => certificate_name }] }
    end

    it "updates certificate" do
      expect(client).to receive(:update)
        .with(certificate_name, certificate_chain: certificate_chain, private_key: private_key)

      certificate.update
    end
  end
end
