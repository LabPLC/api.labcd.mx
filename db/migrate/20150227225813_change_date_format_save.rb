class ChangeDateFormatSave < ActiveRecord::Migration
 def up
    change_column :saves, :fecha, :datetime
  end

  def down
    change_column :saves, :fecha, :date
  end
end