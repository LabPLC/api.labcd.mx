class AddIdVehicleToInfraction < ActiveRecord::Migration
  def change
    add_column :infractions, :id_vehicle, :integer
  end
end
