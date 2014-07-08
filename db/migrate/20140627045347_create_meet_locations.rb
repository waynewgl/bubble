class CreateMeetLocations < ActiveRecord::Migration
  def change
    create_table :meet_locations do |t|
      t.string :location_id
      t.string :user_id
      t.string :enter_time
      t.string :leave_time
      t.string :describe

      t.timestamps
    end
  end
end
