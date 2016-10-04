require 'rest-client'

module Kong
  def hmac_sha1(data, secret="andrewsecret")
      require 'base64'
      require 'openssl'
      hmac = OpenSSL::HMAC.digest(OpenSSL::Digest.new('sha1'), secret, data)
      return Base64.encode64(hmac).strip()
  end

  def ok_response
    begin
      d = Time.now.httpdate
      signature = hmac_sha1("date: #{d}")
      authorization = "hmac username=\"andrew\", algorithm=\"hmac-sha1\", headers=\"date\", signature=\"#{signature}\""

      puts authorization

      return RestClient.get 'http://localhost:8000', {host: 'headers.jsontest.com',
        date: d,
        authorization: authorization
      }
    rescue => e
      return e.response
    end
  end
end
