class CreateMeetGroups < ActiveRecord::Migration
  def change
    create_table :meet_groups do |t|
      t.int :user_id
      t.int :stranger_id
      t.int :location_id
      t.string :address
      t.string :meet_time
      t.timestamps
    end
  end
end
