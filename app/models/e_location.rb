class ELocation < ActiveRecord::Base
  attr_accessible :longitude, :latitude, :address, :begin_date, :content, :end_date, :event_id, :expired_time, :latitude, :longitude, :prepared_for

  belongs_to :event
end
