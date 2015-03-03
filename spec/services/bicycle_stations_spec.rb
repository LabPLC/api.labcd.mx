require 'spec_helper'

require_relative '../../app/services/bicycle_stations'

module BicycleStations
  describe 'are up to date' do

    attr_reader :old_station, :new_station
    
    before do
      @old_station = double 'Station', created_at: 11.days.ago
      @new_station = double 'Station', created_at: 1.days.ago
    end

    it 'unless there are no bicycle stations' do
      stations = []
      expect(BicycleStations.are_up_to_date?(stations)).not_to be
    end

    it 'unless the current bicycle stations are 10 days old' do
      stations = [old_station]
      expect(BicycleStations.are_up_to_date?(stations)).not_to be
    end

    it 'when there are bicycle stations and they are not 10 days old' do
      stations = [new_station]
      expect(BicycleStations.are_up_to_date?(stations)).to be
    end
  end

  describe 'reload stations' do
    attr_reader :fake_response

    before do
      #@fake_response = "{\"stationsStatus\":[{\"id\":1,\"status\":\"OPN\",\"availability\":{\"bikes\":25,\"slots\":2}},{\"id\":2,\"status\":\"OPN\",\"availability\":{\"bikes\":1,\"slots\":11}}]}"
      @fake_response = TestFakeResponse.new("{\"stations\":[{\"id\":3,\"name\":\"3 REFORMA-INSURGENTES\",\"address\":\"003 - Reforma - Insurgentes\",\"addressNumber\":\"S\\/N\",\"zipCode\":\"06500\",\"districtCode\":\"1\",\"districtName\":\"Ampliaci\\u00f3n Granada\",\"nearbyStations\":[8,20,86],\"location\":{\"lat\":19.431655,\"lon\":-99.158668},\"stationType\":\"BIKE,TPV\"},{\"id\":16,\"name\":\"16 REFORMA-RIO GUADALQUIVIR\",\"address\":\"016 - Reforma - Rio Guadalquivir\",\"addressNumber\":\"S\\/N\",\"zipCode\":\"06500\",\"districtCode\":\"1\",\"districtName\":\"Ampliaci\\u00f3n Granada\",\"nearbyStations\":[9,23,24],\"location\":{\"lat\":19.42653,\"lon\":-99.169164},\"stationType\":\"BIKE\"}]}")
    end

    class TestFakeResponse
      attr_reader :body

      def initialize(body)
        @body = body
      end
    end

    it 'calls the endpoint with right url and access token' do
      expect(HTTParty).to receive(:get).with("https://www.test.com", query: { access_token: "access-token" }).and_return(fake_response)
      BicycleStations.reload_stations(url: "https://www.test.com", access_token: "access-token")
    end

    it 'returns the stations list' do
      expect(HTTParty).to receive(:get).with("https://www.test.com", query: { access_token: "access-token" }).and_return(fake_response)
      stations_response = BicycleStations.reload_stations(url: "https://www.test.com", access_token: "access-token")
      expect(stations_response.length).to eq 2

      first_station = stations_response.first
      expect(first_station.id_station).to eq 3
      expect(first_station.name).to eq "3 REFORMA-INSURGENTES"
      expect(first_station.zipCode).to eq "06500"
    end
  end
end

