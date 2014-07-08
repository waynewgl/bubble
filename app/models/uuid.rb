class Uuid < ActiveRecord::Base
  attr_accessible :uuid

  def as_json(options={})
    {
        uuid: self.uuid,
    }
  end


  def generate_uuid
    self.uuid = loop do
      random_uuid = SecureRandom.uuid
      break random_uuid unless Uuid.exists?(UUID: random_uuid)
    end
  end

end
