class BlackList < ActiveRecord::Base
  attr_accessible :reason, :stranger_id, :user_id
end
