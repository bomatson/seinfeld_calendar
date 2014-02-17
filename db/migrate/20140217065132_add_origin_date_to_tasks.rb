class AddOriginDateToTasks < ActiveRecord::Migration
  def change
    add_column :tasks, :origin_date, :datetime
  end
end
