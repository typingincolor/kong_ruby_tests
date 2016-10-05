require 'rest-client'

def hmac_sha1(data, secret="andrewsecret")
  require 'base64'
  require 'openssl'
  hmac = OpenSSL::HMAC.digest(OpenSSL::Digest.new('sha1'), secret, data)
  return Base64.encode64(hmac).strip()
end

def get(headers, date, signature)
  begin
    authorization = "hmac username=\"andrew\", algorithm=\"hmac-sha1\", headers=\"#{headers}\", signature=\"#{signature}\""

    return RestClient.get 'http://localhost:8000', {
        host: 'headers.jsontest.com',
        date: date,
        authorization: authorization
    }
  rescue => e
    return e.response
  end
end

def get_without_authorisation_header(date)
  begin
    return RestClient.get 'http://localhost:8000', {
        host: 'headers.jsontest.com',
        date: date
    }
  rescue => e
    return e.response
  end
end
