require "dnsimple"

module HerokuDnsimpleCert
  class DnsimpleCertificate
    attr_reader :client, :account_id, :domain, :common_name

    def initialize(token:, account_id:, domain:, common_name:, client: nil)
      @client = client || Dnsimple::Client.new(access_token: token)
      @account_id = account_id.to_i
      @domain = domain
      @common_name = common_name
    end

    def certificate_chain
      @certificate_key ||= begin
        cert = client.certificates
          .download_certificate(account_id, domain, certificate.id).data

        [cert.server, cert.root, cert.chain].join("\n")
      end
    end

    def private_key
      @certificate_private_key ||= client.certificates
        .certificate_private_key(account_id, domain, certificate.id)
        .data.private_key
    end

    def certificate
      @certificate ||= client
        .certificates.certificates(account_id, domain)
        .data.select { |certificate| certificate_for_common_name?(certificate) }
        .first
    end

    private

    def certificate_for_common_name?(certificate)
      certificate.state == "issued" &&
        certificate.common_name == common_name
    end
  end
end
