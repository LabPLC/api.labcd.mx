class RenameBicycleStationsFields < ActiveRecord::Migration
  def change
    rename_column :bicycle_stations, :addressNumber, :address_number
    rename_column :bicycle_stations, :zipCode, :zip_code
    rename_column :bicycle_stations, :districtCode, :district_code
    rename_column :bicycle_stations, :nearbyStations, :nearby_stations
    rename_column :bicycle_stations, :stationType, :station_type
  end
end
