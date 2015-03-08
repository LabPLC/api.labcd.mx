require 'rails_helper'


describe 'Ecobici' do
  describe 'GET index' do
    it 'returns stations list' do
      station = create :bicycle_station, created_at: 5.days.ago

      get "/v1/movilidad/estaciones-ecobici"

      stations = JSON.parse(response.body)
      expect(stations.length).to be >= 0
    end
  end

  describe 'GET show' do
    it 'returns station' do
      station = create :bicycle_station, id_station: 4, name: "Station", created_at: 5.days.ago, status: "OPN", bikes: "0", slots: "4"

      get "/v1/movilidad/estaciones-ecobici/#{station.id_station}"

      station = JSON.parse(response.body)
      expect(station["id"]).to eq 4
      expect(station["name"]).to eq "Station"
      expect(station["status"]).to eq "OPN"
      expect(station["slots"].length).to_not eq 0
      expect(station["bikes"].length).to_not eq 0
    end
  end
end
