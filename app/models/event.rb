class Event < ActiveRecord::Base
  attr_accessible :category, :content, :post_time, :report_num, :title, :user_id

  has_many :event_images

  # is reported by user through report event
  has_many :report_events
  has_many :users, :through => :report_events

  belongs_to :category

  has_one :e_location

  has_many :comments

  def as_json(options={})
    {
        id: self.id,
        #uuid: self.uuid,
        category_id: self.category_id,
        title: self.checkTitle,
        content: self.content,
        post_user: self.post_user,
        post_time: self.updated_at.localtime,
        event_image: self.event_images,
        event_location: self.getEventLocations,
        comment_count: self.comments.count
    }
  end

  def countEventComments

    comment_count = Comment.find_by_sql("select count(*) from comments where comments.event_id = #{self.id}")
    return comment_count
  end

  def checkTitle

    if self.title.nil?

      return ""

    else

      return self.title
    end

  end

  def post_user

    user = User.find_by_id(self.user_id)

    if user.nil?

      return ""
    else

      return user
    end
  end

  def getEventLocations

    if  self.e_location != nil

      return self.e_location

    else

      return ""
    end
  end

end
