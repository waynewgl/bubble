class CreateFeedBacks < ActiveRecord::Migration
  def change
    create_table :feed_backs do |t|
      t.string :user_id
      t.string :content

      t.timestamps
    end
  end
end
