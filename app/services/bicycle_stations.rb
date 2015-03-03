module BicycleStations
  include HTTParty

  def self.are_up_to_date?(stations_records)
    stations_records.any? && !any_station_created_before?(10.days.ago, stations_records)
  end

  def self.reload_stations(url:, access_token:)
    response = HTTParty.get(url, query: { access_token: access_token })
    generate_bycicle_stations(JSON.parse(response.body)["stations"])
  end

  private

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