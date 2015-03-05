class CreateInfractions < ActiveRecord::Migration
  def change
    create_table :infractions do |t|
      t.text :folio
      t.text :fecha
      t.text :situacion
      t.text :motivo
      t.text :fundamento
      t.text :sancion

      t.timestamps null: false
    end
  end
end
