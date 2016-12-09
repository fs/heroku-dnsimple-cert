require "spec_helper"

describe HerokuDnsimpleCert do
  describe ".create_or_update" do
    let(:dnsimple_certificate) do
      instance_double(HerokuDnsimpleCert::DnsimpleCertificate,
        certificate_chain: "certificate_chain", private_key: "private_key")
    end

    let(:heroku_certificate) do
      instance_double(HerokuDnsimpleCert::HerokuCertificate, create_or_update: true)
    end

    before do
      allow(HerokuDnsimpleCert::DnsimpleCertificate).to receive(:new) { dnsimple_certificate }
      allow(HerokuDnsimpleCert::HerokuCertificate).to receive(:new) { heroku_certificate }
    end

    it "updates or creates Heroku certificate" do
      expect(heroku_certificate).to receive(:create_or_update)
      described_class.create_or_update
    end
  end
end
