class CreateMeetGroups < ActiveRecord::Migration
  def change
    create_table :meet_groups do |t|
      t.integer :user_id
      t.integer :stranger_id
      t.integer :location_id
      t.string :address
      t.string :meet_time
      t.timestamps
    end
  end
end
