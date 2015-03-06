# semovi_taxis/A05601

require 'rails_helper'

describe 'Vehicles' do
  describe 'GET show' do
    it 'returns the vehicle information' do
      get '/v1/movilidad/taxis/A05601'
      taxi = JSON.parse(response.body)

      expect(response_endpoint_keys_in(body: taxi, children: [
        "id",
        "code",
        "placa",
        "marca_modelo",
        "status",
        "fecha",
        "created_at",
        "updated_at"
      ])).to be
    end
  end
end
