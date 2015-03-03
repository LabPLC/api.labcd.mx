module BicycleStations
  include HTTParty

  def self.are_up_to_date?(stations_records)
    stations_records.any? && all_stations_created_after?(10.days.ago, stations_records)
  end

  def self.reload_stations(url:, access_token:)
    response = HTTParty.get(url, query: { access_token: access_token })
    generate_bycicle_stations(JSON.parse(response.body)["stations"])
  end

  def self.stations_for(stations_records)
    stations_records.map { |station| station_response(station) }
  end

  def self.station_response(station_record)
    {
      id: station_record.id_station,
      name: station_record.name,
      address: station_record.address,
      address_number: station_record.address_number,
      zip_code: station_record.zip_code,
      district_code: station_record.district_code,
      nearby_stations: station_record.nearby_stations,
      location: station_record.location,
      station_type: station_record.station_type,
      created_at: station_record.created_at,
      updated_at: station_record.updated_at
    }
  end

  def self.station_status_response(station_record)
    station_response(station_record).merge(
    {
      status: station_record.status,
      bikes: station_record.bikes,
      slots: station_record.slots
    })
  end

  def self.reload_stations_status(url:, access_token:, records:)
    response = HTTParty.get(url, query: { access_token: access_token })
    update_bycicle_stations_status(JSON.parse(response.body)["stationsStatus"], records)
  end

  private

  def self.update_bycicle_stations_status(stations_status, stations)
    stations.each do |station|
      status = stations_status.select { |status| status["id"] == station.id_station }.first
      station.status = status["status"]
      station.slots = status["availability"]["slots"]
      station.bikes = status["availability"]["bikes"]
    end

    stations
  end

  def self.generate_bycicle_stations(stations)
    stations.map do |station|
      BicycleStation.new(
        id_station: station['id'],
        name: station['name'],
        address: station['address'],
        address_number: station['addressNumber'],
        zip_code: station['zipCode'],
        district_code: station['districtCode'],
        nearby_stations: station['nearbyStations'].join(', '),
        location: "#{station['location']['lat']}, #{station['location']['lon']}",
        station_type: station['stationType']
      )
    end
  end

  def self.all_stations_created_after?(days_ago, stations)
    stations.all? { |station| station.created_at > days_ago }
  end
end