class UserReport < ActiveRecord::Base
  attr_accessible :reason, :stranger_id, :user_id


  belongs_to :user

end
