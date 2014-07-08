class EventLocation < ActiveRecord::Base
  attr_accessible :event_id, :location_id

  belongs_to :event
  belongs_to :location

end
