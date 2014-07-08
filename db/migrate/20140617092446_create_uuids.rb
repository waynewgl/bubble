class CreateUuids < ActiveRecord::Migration
  def change
    create_table :uuids do |t|
      t.string :uuid

      t.timestamps
    end
  end
end
