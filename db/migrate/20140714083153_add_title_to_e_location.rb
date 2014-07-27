class AddTitleToELocation < ActiveRecord::Migration
  def change
    add_column :e_locations, :title, :string
  end
end
