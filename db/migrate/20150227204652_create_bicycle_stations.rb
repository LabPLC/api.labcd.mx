class CreateBicycleStations < ActiveRecord::Migration
  def change
    create_table :bicycle_stations do |t|
      t.integer :id_station
      t.text :name
      t.text :address
      t.text :addressNumber
      t.text :zipCode
      t.text :districtCode
      t.text :nearbyStations
      t.text :location
      t.text :stationType
      t.timestamps null: false
    end
  end
end
