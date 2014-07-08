class CreateEvents < ActiveRecord::Migration
  def change
    create_table :events do |t|
      t.string :category_id
      t.string :title
      t.string :content
      t.string :post_time
      t.string :user_id
      t.string :report_num

      t.timestamps
    end
  end
end
