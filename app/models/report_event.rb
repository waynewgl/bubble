class ReportEvent < ActiveRecord::Base
  attr_accessible :event_id, :reason, :user_id


  belongs_to :event
  belongs_to :user

end
