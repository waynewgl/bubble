#encoding: UTF-8

class User < ActiveRecord::Base

  attr_accessible :UUID, :is_loggedin, :nickname, :account, :password

  attr_accessible :avatar , :avatar_content_type, :avatar_file_name, :avatar_file_size, :avatar_updated_at

  #has_many :meet_locations
  #has_many :locations, :through => :meet_locations

  has_one :location

  #report event...
  has_many :report_events
  has_many :events, :through => :report_events

  has_many :comments, :through => :comments

  has_attached_file :avatar, :styles => { :small => "150x150>", :content => "800x800>", :thumb => "60x60>", :thumb_small=>"30x30>" },
                    :url => "/upload/avatars/:class/user/:id/:style_:basename.:extension"  ,
                    :path => ":rails_root/public/upload/avatars/:class/user/:id/:style_:basename.:extension"

  def as_json(options={})
    {
        id: self.id,
        #uuid: self.uuid,
        major: self.major,
        email: self.email,
        sex: self.sex,
        image_url: self.checkAvatar,
        nickname: self.checkNickName,
        is_logged: self.is_loggedin,
        age: self.dob
    }
  end


  def generate_major
    self.major = loop do
      random_major = SecureRandom.base64(self.id)
      break random_major unless User.exists?(major: random_major)
    end
  end


  def checkAvatar

    url =  self.avatar.url.to_s

    if  url == '/avatars/original/missing.png'

      return ""

    else

      return url
    end
  end


  def checkNickName

    if self.nickname.nil? || self.nickname.blank?

      return "路人NO.#{self.id}"
    else

      return self.nickname
    end

  end

  def generate_token
    self.passport_token = loop do
      random_token = SecureRandom.urlsafe_base64(nil, false)
      break random_token unless User.exists?(passport_token: random_token)
    end
  end

end