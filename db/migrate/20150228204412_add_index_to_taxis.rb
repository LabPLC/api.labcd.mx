class AddIndexToTaxis < ActiveRecord::Migration
  def change
    add_index :taxis, :placa, unique: true
  end
end
