class Category < ActiveRecord::Base
  attr_accessible :introdution, :name

  has_many :events


  def as_json(options={})
    {
        id: self.id,
        name: self.name,
        introduction: self.introduction
    }
  end

end
