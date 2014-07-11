class MeetGroup < ActiveRecord::Base
  attr_accessible :user_id, :stanger_id, :location_id, :meet_time
end
