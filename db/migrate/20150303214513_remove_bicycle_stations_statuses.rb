class RemoveBicycleStationsStatuses < ActiveRecord::Migration
  def change
    drop_table :bicycle_stations_statuses
  end
end
