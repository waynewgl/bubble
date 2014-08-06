class AddViewNumToEvent < ActiveRecord::Migration
  def change
    add_column :events, :viewNum, :string
  end
end
