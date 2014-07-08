class AddAttachmentImageToEventImages < ActiveRecord::Migration
  def self.up
    change_table :event_images do |t|
      t.attachment :image
    end
  end

  def self.down
    drop_attached_file :event_images, :image
  end
end
