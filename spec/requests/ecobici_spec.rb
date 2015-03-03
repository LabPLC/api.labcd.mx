require 'rails_helper'

describe 'Ecobici' do
  describe 'GET index' do
    it 'returns stations list' do
      station = create :bicycle_station, created_at: 5.days.ago

      get '/bicycle_stations'

      stations = JSON.parse(response.body)
      expect(stations.length).to eq 1
    end
  end

  describe 'GET show' do
    it 'returns station' do
      station = create :bicycle_station, id_station: 4, name: "Station", created_at: 5.days.ago

      get "/bicycle_stations/#{station.id_station}"

      station = JSON.parse(response.body)
      expect(station["id_station"]).to eq 4
      expect(station["name"]).to eq "Station"
    end
  end
end
