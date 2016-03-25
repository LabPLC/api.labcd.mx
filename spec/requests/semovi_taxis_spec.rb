#encoding: utf-8
require 'rails_helper'

describe 'Semovi taxis' do
  describe 'GET /:placa' do
    it 'returns a taxi' do
      create :taxi, placa: 'A12345', code: 'taxi-code'

      request_params = { id: 'a12345' }

      get v1_movilidad_semovi_taxi_path(request_params)

      expect(response.status).to eq 200

      taxi = JSON.parse(response.body)
      expect(taxi["code"]).to eq 'taxi-code'
      expect(taxi["placa"]).to eq 'A12345'
    end

    it "returns 'placa invalida' error message" do
      request_params = { id: 'inv-pl' }

      get v1_movilidad_semovi_taxi_path(request_params)

      error = JSON.parse(response.body)["error"]
      expect(error).to eq "placa inválida"
    end
  end
end
