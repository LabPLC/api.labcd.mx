module BicycleStations
  include HTTParty

  def self.are_up_to_date?(stations_records)
    stations_records.any? && !any_station_created_before?(10.days.ago, stations_records)
  end

  def self.reload_stations(url:, access_token:)
    response = HTTParty.get(url, query: { access_token: access_token })
    generate_bycicle_stations(JSON.parse(response.body)["stations"])
  end

  def self.station_status_for(station_record)
    {
      id: station_record.id_station,
      status: station_record.status,
      bikes: station_record.bikes,
      slots: station_record.slots
    }
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
        addressNumber: station['addressNumber'],
        zipCode: station['zipCode'],
        districtCode: station['districtCode'],
        nearbyStations: station['nearbyStations'].join(', '),
        location: "#{station['location']['lat']}, #{station['location']['lon']}",
        stationType: station['stationType']
      )
    end
  end

  def self.any_station_created_before?(days_ago, stations)
    stations.select { |station| station.created_at <= days_ago }.first.present?
  end
end