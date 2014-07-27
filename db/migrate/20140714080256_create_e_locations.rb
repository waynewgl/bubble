class CreateELocations < ActiveRecord::Migration
  def change
    create_table :e_locations do |t|

      t.integer :event_id
      t.float :longitude
      t.float :latitude
      t.string :address
      t.string :content
      t.string :title
      t.string :prepared_for
      t.datetime :begin_date
      t.datetime :end_date
      t.datetime :expired_time

      t.timestamps
    end
  end
end
