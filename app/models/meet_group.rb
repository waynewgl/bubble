#encoding: UTF-8

class MeetGroup < ActiveRecord::Base
  attr_accessible :user_id, :stanger_id, :location_id, :meet_time


  def as_json(options={})
    {

        address: self.checkAddress,
        created_at: self.created_at.localtime,
        id: self.id,
        meet_time: self.meet_time,
        stranger_id: self.stranger_id,
        total_meet: self.total_meet,
        updated_at: self.updated_at.localtime,
        user_id: self.user_id
    }
  end


  def checkAddress

    if  self.address.nil?  || self.address == "<null>"

      return "未知地址"
    else

      return self.address
    end

  end

end
