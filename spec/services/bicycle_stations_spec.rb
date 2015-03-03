require 'spec_helper'

require_relative '../../app/services/bicycle_stations'

module BicycleStations

  class TestFakeResponse
    attr_reader :body

    def initialize(body)
      @body = body
    end
  end

  class TestBicycleStation
    attr_reader :id_station
    attr_accessor :status, :slots, :bikes, :name, :address, :address_number, :zip_code, :district_code, :nearby_stations, :location, :station_type, :created_at, :updated_at

    def initialize(attrs)
      @id_station = attrs[:id_station]
      @name = attrs[:name]
      @address = attrs[:address]
      @address_number =  attrs[:address_number]
      @zip_code = attrs[:zip_code]
      @district_code = attrs[:district_code]
      @nearby_stations = attrs[:nearby_stations]
      @location = attrs[:location]
      @station_type = attrs[:station_type]
      @created_at = attrs[:created_at]
      @updated_at = attrs[:updated_at]
      @status = attrs[:status]
      @slots = attrs[:slots]
      @bikes = attrs[:bikes]
    end
  end

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
      @fake_response = TestFakeResponse.new("{\"stations\":[{\"id\":3,\"name\":\"3 REFORMA-INSURGENTES\",\"address\":\"003 - Reforma - Insurgentes\",\"addressNumber\":\"S\\/N\",\"zipCode\":\"06500\",\"districtCode\":\"1\",\"districtName\":\"Ampliaci\\u00f3n Granada\",\"nearbyStations\":[8,20,86],\"location\":{\"lat\":19.431655,\"lon\":-99.158668},\"stationType\":\"BIKE,TPV\"},{\"id\":16,\"name\":\"16 REFORMA-RIO GUADALQUIVIR\",\"address\":\"016 - Reforma - Rio Guadalquivir\",\"addressNumber\":\"S\\/N\",\"zipCode\":\"06500\",\"districtCode\":\"1\",\"districtName\":\"Ampliaci\\u00f3n Granada\",\"nearbyStations\":[9,23,24],\"location\":{\"lat\":19.42653,\"lon\":-99.169164},\"stationType\":\"BIKE\"}]}")
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
      expect(first_station.zip_code).to eq "06500"
    end
  end

  describe 'station status response' do
    attr_reader :station

    before do
      @station = TestBicycleStation.new(status: "OPN", slots: "4", bikes: "3", id_station: 4)
    end

    it 'returns the id of the station' do
      expect(BicycleStations.station_status_response(station)[:id]).to eq 4
    end

    it 'returns the status of the station' do
      expect(BicycleStations.station_status_response(station)[:status]).to eq "OPN"
    end

    it 'returns the number of slots of the station' do
      expect(BicycleStations.station_status_response(station)[:slots]).to eq "4"
    end

    it 'returns the number of bikes of the station' do
      expect(BicycleStations.station_status_response(station)[:bikes]).to eq "3"
    end
  end

  describe 'station response' do
    attr_reader :station

    before do
      @station = TestBicycleStation.new(id_station: 4, name: "Name", address: "Address", address_number: "Address number", zip_code: "80800", district_code: "X", nearby_stations: "1, 2", location: "Loc", station_type: "type", created_at: 1.day.ago, updated_at: 1.day.ago)
    end

    it "returns the #{attr} for the station" do
      expect(BicycleStations.station_response(station)[:id]).to eq 4
    end
    
    [:name, :address, :address_number, :zip_code, :district_code, :nearby_stations, :location, :station_type, :created_at, :updated_at].each do |attr|
      it "returns the #{attr} for the station" do
        expect(BicycleStations.station_response(station)[attr]).to eq station.send(attr)
      end
    end
  end

  describe 'reload stations status' do
    attr_reader :fake_response, :stations

    before do
      @fake_response = TestFakeResponse.new("{\"stationsStatus\":[{\"id\":1,\"status\":\"OPN\",\"availability\":{\"bikes\":25,\"slots\":2}},{\"id\":2,\"status\":\"OPN\",\"availability\":{\"bikes\":1,\"slots\":11}}]}")
      @stations = [TestBicycleStation.new(id_station: 1), TestBicycleStation.new(id_station: 2)]
    end

    it 'calls the endpoint with right url and access token' do
      expect(HTTParty).to receive(:get).with("https://www.test.com/status", query: { access_token: "access-token" }).and_return(fake_response)
      BicycleStations.reload_stations_status(url: "https://www.test.com/status", access_token: "access-token", records: [])
    end

    it 'returns the stations list' do
      expect(HTTParty).to receive(:get).with("https://www.test.com/status", query: { access_token: "access-token" }).and_return(fake_response)
      stations_status_response = BicycleStations.reload_stations_status(url: "https://www.test.com/status", access_token: "access-token", records: stations)

      first_status = stations_status_response.first
      expect(first_status.id_station).to eq 1
      expect(first_status.status).to eq "OPN"
      expect(first_status.slots).to eq 2
      expect(first_status.bikes).to eq 25
    end
  end
end

