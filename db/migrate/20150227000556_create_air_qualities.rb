class CreateAirQualities < ActiveRecord::Migration
  def change
    create_table :air_qualities do |t|
      t.text :title
      t.text :link
      t.text :description
      t.integer :reporte
      t.text :imagenclima
      t.integer :gradosclima
      t.text :calairuser
      t.text :colairuser
      t.text :iconairuser
      t.text :colairno
      t.text :calairno
      t.text :colairne
      t.text :calairne
      t.text :colairce
      t.text :calairce
      t.text :colairso
      t.text :calairso
      t.text :colairse
      t.text :calairse
      t.text :imgiuvuser
      t.text :caliuvuser
      t.text :coliuvuser
      t.timestamps null: false
    end
  end
end
