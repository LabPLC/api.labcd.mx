class AddStatusToBicycleStations < ActiveRecord::Migration
  def change
    add_column :bicycle_stations, :status, :string
    add_column :bicycle_stations, :bikes, :string
    add_column :bicycle_stations, :slots, :string
  end
end
