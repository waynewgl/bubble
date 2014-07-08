class CreateMeetGroups < ActiveRecord::Migration
  def change
    create_table :meet_groups do |t|
      t.string :senderID
      t.string :receiverID
      t.timestamps
    end
  end
end
