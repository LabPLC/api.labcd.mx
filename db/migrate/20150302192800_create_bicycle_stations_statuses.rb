class CreateBicycleStationsStatuses < ActiveRecord::Migration
  def change
    create_table :bicycle_stations_statuses do |t|
      t.integer :id_station
      t.string :status
      t.string :bikes
      t.string :slots

      t.timestamps null: false
    end
  end
end
