class CreateEventImages < ActiveRecord::Migration
  def change
    create_table :event_images do |t|
      t.string :event_id
      t.string :width
      t.string :height

      t.timestamps
    end
  end
end
