class CreateVehicles < ActiveRecord::Migration
  def change
    create_table :vehicles do |t|
      t.text :placa
      t.text :fechas_adeudo_tenecia
      t.text :tiene_adeudo_tenencia

      t.timestamps null: false
    end
  end
end
