require "spec_helper"

describe HerokuDnsimpleCert::DnsimpleCertificate do
  def struct_certificate(id, state, common_name)
    instance_double(Dnsimple::Struct::Certificate, id: id, state: state, common_name: common_name)
  end

  def struct_sertificate_bundle(args)
    instance_double(Dnsimple::Struct::CertificateBundle, args)
  end

  def response(data)
    instance_double(Dnsimple::Response, data: data)
  end

  let(:token) { "token" }
  let(:account_id) { 123 }
  let(:domain) { "example.com" }
  let(:common_name) { "www.example.com" }

  let(:valid_certificate) { struct_certificate("1", "issued", common_name) }
  let(:invalid_certificate) { struct_certificate("2", "issued", "google.com") }
  let(:certificates_response) { response([valid_certificate, invalid_certificate]) }

  let(:certificates_service) { instance_double(Dnsimple::Client::CertificatesService) }
  let(:client) { instance_double(Dnsimple::Client) }

  let(:certificate) do
    described_class.new(
      token: token, account_id: account_id,
      domain: domain, common_name: common_name,
      client: client
    )
  end

  before do
    allow(client).to receive(:certificates) { certificates_service }
    allow(certificates_service).to receive(:certificates).with(account_id, domain) { certificates_response }
  end

  describe "#certificate_chain" do
    let(:certificate_bundle) { struct_sertificate_bundle(server: "server", root: "root", chain: "chain") }
    let(:certificate_chain_response) { response(certificate_bundle) }

    before do
      allow(certificates_service).to receive(:download_certificate)
        .with(account_id, domain, valid_certificate.id) { certificate_chain_response }
    end

    it "returns certificate chain" do
      expect(certificate.certificate_chain).to eql("server\nroot\nchain")
    end
  end

  describe "#private_key" do
    let(:certificate_bundle) { struct_sertificate_bundle(private_key: "private_key") }
    let(:certificate_private_key_response) { response(certificate_bundle) }

    before do
      allow(certificates_service).to receive(:certificate_private_key)
        .with(account_id, domain, valid_certificate.id) { certificate_private_key_response }
    end

    it "returns private key" do
      expect(certificate.private_key).to eql("private_key")
    end
  end
end
