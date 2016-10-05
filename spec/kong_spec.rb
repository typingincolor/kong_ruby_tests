require 'spec_helper'

describe('rideways-api') do
  it('should return OK if the signature and date are correct') do
    d = Time.now.httpdate
    signature = hmac_sha1("date: #{d}")

    response = get "date", d, signature

    expect(response.code).to eq(200)
  end

  it('should return 403 if the date is incorrect') do
    d = "Mon, 20 Aug 2011 14:38:05 GMT";
    signature = hmac_sha1("date: #{d}")

    response = get "date", d, signature

    expect(response.code).to eq(403)
  end

  it('should return 403 if the signature is incorrectly signed') do
    d = Time.now.httpdate
    signature = hmac_sha1("date: #{d}", "badsignature")

    response = get "date", d, signature

    expect(response.code).to eq(403)
  end

  it('should return 401 if the authorization header is missing') do
    d = Time.now.httpdate
    response = get_without_authorisation_header d
    expect(response.code).to eq(401)
  end

  it('should return OK for a POST if the signature and date are correct') do
    payload = {:message => "a message"}.to_json

    content_sha256 = sha256(payload);

    d = Time.now.httpdate
    signature = hmac_sha1("date: #{d}\nx-content-sha256: #{content_sha256}")

    response = post "date x-content-sha256", d, signature, payload, content_sha256
    expect(response.code).to eq(200)
  end
end
