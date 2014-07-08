class Location < ActiveRecord::Base
  attr_accessible :content, :latitude, :longitude, :user_id

  has_many :meet_locations
  has_many :users, :through => :meet_locations

  has_many :event_locations
  has_many :events, :through => :event_locations

  def as_json(options={})
    {
        id: self.id,
        #uuid: self.uuid,
        longitude: self.longitude,
        latitude: self.latitude,
        recorded_at: self.start_date.localtime,
        content: self.content,
        user_id: self.user_id
    }
  end

end
