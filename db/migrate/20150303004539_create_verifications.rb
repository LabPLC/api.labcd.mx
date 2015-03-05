class CreateVerifications < ActiveRecord::Migration
  def change
    create_table :verifications do |t|
      t.text :vin
      t.text :marca
      t.text :submarca
      t.text :modelo
      t.text :combustible
      t.text :certificado
      t.text :cancelado
      t.text :vigencia
      t.text :verificentro
      t.text :linea
      t.text :fecha_verificacion
      t.text :hora_verificacion
      t.text :resultado
      t.text :causa_rechazo
      t.text :equipo_gdf

      t.timestamps null: false
    end
  end
end
