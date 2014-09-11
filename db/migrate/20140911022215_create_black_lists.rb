class CreateBlackLists < ActiveRecord::Migration
  def change
    create_table :black_lists do |t|
      t.string :user_id
      t.string :stranger_id
      t.string :reason

      t.timestamps
    end
  end
end
