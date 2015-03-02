class CreateSaves < ActiveRecord::Migration
  def change
    create_table :saves do |t|
      t.text :access_token
      t.datetime :fecha
      t.timestamps null: false
    end
  end
end
