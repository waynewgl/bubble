class CreateLocations < ActiveRecord::Migration
  def change
    create_table :locations do |t|
      t.string :user_id
      t.string :longitude
      t.string :latitude
      t.string :content
      t.string :title

      t.timestamps
    end
  end
end
