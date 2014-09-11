class BlackList < ActiveRecord::Base
  attr_accessible :reason, :stranger_id, :user_id

  def as_json(options={})
    {
        id: self.id,
        user_id: self.user_id,
        stranger_id: self.stranger_id,
        stranger: self.getStrangerInfo

    }
  end


  def getStrangerInfo

    user = User.find_by_id(self.stranger_id)

    if user.nil?

      return ""
    else

      return user
    end

  end

end
