class AddIdVehicleToVerification < ActiveRecord::Migration
  def change
    add_column :verifications, :id_vehicle, :integer
  end
end
