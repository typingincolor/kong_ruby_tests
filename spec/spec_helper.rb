require 'rest-client'

def hmac_sha1(data, secret="andrewsecret")
  require 'base64'
  require 'openssl'
  hmac = OpenSSL::HMAC.digest(OpenSSL::Digest.new('sha1'), secret, data)
  return Base64.encode64(hmac).strip()
end

def sha256(data)
  require 'digest'
  return Digest::SHA256.hexdigest(data)
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

def post(headers, date, signature, payload, content_sha256)
  begin
    authorization = "hmac username=\"andrew\", algorithm=\"hmac-sha1\", headers=\"#{headers}\", signature=\"#{signature}\""

    return RestClient.post 'http://localhost:8000', payload, {
      host: 'headers.jsontest.com',
      date: date,
      authorization: authorization,
      x_content_sha256: content_sha256
    }
  rescue => e
    return e.response
  end
end
