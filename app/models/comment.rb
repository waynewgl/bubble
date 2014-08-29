class Comment < ActiveRecord::Base
  attr_accessible :content, :event_id, :user_id

  belongs_to :user
  belongs_to :event


  def as_json(options={})
    {
        id: self.id,
        #uuid: self.uuid,
        event_id: self.event_id,
        content: self.content,
        user: self.post_user,
        post_date: self.created_at.localtime
    }
  end


  def post_user

    user = User.find_by_id(self.user_id)

    return user
  end


end
