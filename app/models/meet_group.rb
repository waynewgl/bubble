class MeetGroup < ActiveRecord::Base
  attr_accessible :user_id, :stanger_id, :location_id, :meet_time


  def as_json(options={})
    {

        address: self.address,
        created_at: self.created_at.localtime,
        id: self.id,
        meet_time: self.meet_time,
        stranger_id: self.stranger_id,
        total_meet: self.total_meet,
        updated_at: self.updated_at.localtime,
        user_id: self.user_id
    }
  end


end
