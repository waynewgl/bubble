class CreateEventLocations < ActiveRecord::Migration
  def change
    create_table :event_locations do |t|
      t.string :event_id
      t.string :location_id

      t.timestamps
    end
  end
end
