class CreateSemoviTaxis < ActiveRecord::Migration
  def change
    create_table :taxis do |t|
      t.text :code
      t.text :placa
      t.text :marca_modelo
      t.text :status
      t.datetime :fecha
      t.timestamps null: false
    end
  end
end
