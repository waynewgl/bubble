class CreateFavorates < ActiveRecord::Migration
  def change
    create_table :favorates do |t|
      t.string :event_id
      t.string :user_id
      t.string :content

      t.timestamps
    end
  end
end
