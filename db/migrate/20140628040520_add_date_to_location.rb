class AddDateToLocation < ActiveRecord::Migration
  def change
    add_column :locations, :start_date, :datetime
    add_column :locations, :end_date, :datetime
  end
end
