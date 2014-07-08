class MeetLocation < ActiveRecord::Base
  attr_accessible :describe, :enter_time, :leave_time, :location_id, :user_id

   belongs_to :user
   belongs_to :location

end
