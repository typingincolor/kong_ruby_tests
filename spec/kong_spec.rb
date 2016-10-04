require 'rest-client'
require './kong'

include Kong

describe('rideways-api') do
  it('should return OK') do
    response = Kong.ok_response

    expect(response.code).to eq(200)
  end

end
