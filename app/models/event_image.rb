class EventImage < ActiveRecord::Base
  attr_accessible :event_id, :height, :width

  attr_accessible :image , :image_content_type, :image_file_name, :image_file_size, :image_updated_at

  has_attached_file :image, :styles => { :small => "150x150>", :content => "800x800>", :thumb => "60x60>", :thumb_small=>"30x30>" },
                    :url => "/upload/images/:class/event/:id/:style_:basename.:extension"  ,
                    :path => ":rails_root/public/upload/images/:class/event/:id/:style_:basename.:extension"

  belongs_to :event

  def as_json(options={})
    {
        id: self.id,
        #uuid: self.uuid,
        event_id: self.event_id,
        width: self.width,
        height: self.height,
        image: self.image.url,
    }
  end


end
