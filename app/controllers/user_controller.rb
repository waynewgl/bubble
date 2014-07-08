#encoding: UTF-8
class UserController < ApplicationController
  protect_from_forgery
  include CodeHelper

  def index


  end

  api :POST, "/user/report_event", "用户举报事件"

  param :event_id, String, "举报的event id", :required => true
  param :user_id, String, "用户 id", :required => true
  param :reason, String, "举报原因", :required => true

  description <<-EOS


  EOS

  def report_event

    msg = Hash.new

    if params[:event_id].nil? ||  params[:user_id].nil? ||  params[:reason].nil?  || params[:passport_token].nil?

      arr_params = ["event_id", "user_id", "reason", "passport token"]
      msg[:response] = CodeHelper.CODE_MISSING_PARAMS(arr_params)
      msg[:description] = "请填写所需参数..."
      render :json =>  msg.to_json
      return
    else

      event = Event.find_by_id(params[:event_id])
      if event.nil?

        msg[:response] = CodeHelper.CODE_FAIL
        msg[:description] = "没有该事件"
        render :json =>  msg.to_json
        return
      end

      checkUser = checkUserExistBeforeOperationStart(params[:user_id], msg)

      if checkUser

       reportEvent = ReportEvent.new
       reportEvent.event_id = params[:event_id]
       reportEvent.user_id = params[:user_id]
       reportEvent.reason = params[:reason]

        if reportEvent.save

         msg[:response] = CodeHelper.CODE_SUCCESS
         msg[:description] = "举报成功"
         render :json =>  msg.to_json
         return

       else
         msg[:response] = CodeHelper.CODE_FAIL
         msg[:description] = "举报失败"
         render :json =>  msg.to_json
         return
       end

      end
    end
  end


  def findUUID

    uuid = Uuid.find_by_id(1)
    if uuid.nil?

      uuid = Uuid.new
      uuid.uuid = uuid.generate_uuid
      uuid.save
    end
    return  uuid.uuid
  end

  api :POST, "/user/register", "用户注册"

  param :account, String, "用户account", :required => true
  param :password, String, "用户password", :required => true
  param :device_uuid, String, "用户device UUID", :required => true

  description <<-EOS


  EOS

  def register

    msg = Hash.new

    if params[:account].nil? ||  params[:password].nil? ||  params[:device_uuid].nil?

      arr_params = ["account", "password", "device_uuid"]
      msg[:response] = CodeHelper.CODE_MISSING_PARAMS(arr_params)
      msg[:description] = "请填写所需信息..."
      render :json =>  msg.to_json
      return
    end

    user = User.where("account = ? and password = ?", params[:account], Digest::SHA1.hexdigest(params[:password]) ).first

    if user.nil?

      new_user = User.new
      new_user.account = params[:account]
      new_user.password =  Digest::SHA1.hexdigest(params[:password])
      new_user.email = params[:email]
      new_user.nickname = params[:nickname]
      new_user.uuid = params[:device_uuid]
      #new_user.uuid = new_user.generate_major

      if new_user.save

        msg[:response] = CodeHelper.CODE_SUCCESS
        msg[:user] = new_user
        msg[:description] = "用户注册成功"
        render :json =>  msg.to_json

      else

        msg[:response] = CodeHelper.CODE_FAIL
        msg[:description] = "用户注册失败"
        render :json =>  msg.to_json
      end
    else

      msg[:response] = CodeHelper.CODE_FAIL
      msg[:description] = "该用户已经存在，请重新选用其他账号注册"
      render :json =>  msg.to_json
    end

  end


  api :GET, "/user/userLogin", "用户登陆"

  param :account, String, "用户account", :required => true
  param :password, String, "用户password", :required => true
  param :device_uuid, String, "用户 device uuid", :required => true

  description <<-EOS


  EOS
  def userLogin

    msg = Hash.new

    if params[:account].nil? ||  params[:password].nil?  ||  params[:device_uuid].nil?

      arr_params = ["account", "password", "device_uuid"]
      msg[:response] = CodeHelper.CODE_MISSING_PARAMS(arr_params)
      msg[:description] = "请填写所需信息..."
      render :json =>  msg.to_json
      return
    end

    user = User.where("account = ? and password = ? and uuid = ?", params[:account], Digest::SHA1.hexdigest(params[:password]), params[:device_uuid] ).first

    if user.nil?

      msg[:response] = CodeHelper.CODE_USER_NOT_EXIST
      msg[:user] = ""
      msg[:description] = "该用户不存在"
      render :json =>  msg.to_json
    else
      msg[:response] = CodeHelper.CODE_SUCCESS
      user.passport_token = nil
      msg[:passport_token] =  user.generate_token
      user.update_attribute(:passport_token, msg[:passport_token] )
      msg[:user] = user
      msg[:description] = "登陆成功"
      render :json =>  msg.to_json
    end

  end

  api :POST, "/user/upload_avatar_ios", "用户上传头像"

  param :user_id, String, "用户id", :required => true
  param :avatar, String, "用户头像数据", :required => true
  param :passport_token, String, "用户令牌，用于操作的身份验证", :required => true

  description <<-EOS
    用于用户上传头像
    上传成功 返回：
    {
      response: #{CodeHelper.CODE_SUCCESS}
      user_id:1
      image_url:""
      description:“用户上传头像成功”
    }

    上传失败 返回：
    {
      response: #{CodeHelper.CODE_FAIL}
      description:“用户上传头像失败”
    }

    用户不存在 返回
    {
      response:#{CodeHelper.CODE_USER_NOT_EXIST}
      description:“用户不存在，无法上传头像”
    }


  EOS
  def upload_avatar_ios

    msg = Hash.new

    if params[:avatar].nil? || params[:user_id].blank? || params[:passport_token].blank?

      arr_params = ["avatar", "user_id", "passport token"]
      msg[:response] = CodeHelper.CODE_MISSING_PARAMS(arr_params)
      msg[:description] = "缺少必要参数"
      render :json =>  msg
      return
    else

      user = User.find_by_id(params[:user_id])

      if user.nil?

        msg[:response] =CodeHelper.CODE_USER_NOT_EXIST
        msg[:description] = "用户不存在"
        render :json =>  msg
        return
      else

        if user.passport_token !=  params[:passport_token]

          msg[:response] =CodeHelper.CODE_TOKEN_NOT_EXIST
          msg[:description] = "用户 passport token 不存在或者失效"
          render :json =>  msg
          return
        end

        if user.update_attributes(:avatar => params[:avatar])

          render :json =>  user
          return
        else

          msg[:response] =CodeHelper.CODE_FAIL
          msg[:description] = "用户上传头像失败"
          render :json =>  msg
          return
        end
      end
    end
  end



  api :POST, "/user/recordLocation", "用户记录位置信息"

  param :longitude, String, "用户位置longitude", :required => true
  param :latitude, String, "用户位置latitude", :required => true
  param :start_time, String, "用户位置记录时间", :required => true
  param :user_id, String, "用户 id", :required => true
  param :passport_token, String, "用户令牌，用于操作的身份验证", :required => true

  description <<-EOS


  EOS
  def recordLocation

    msg = Hash.new

    if params[:longitude].nil? || params[:latitude].nil?  || params[:user_id].nil?   || params[:passport_token].nil?   || params[:start_time].nil?
      arr_params = ["longitude", "latitude", "user_id", "passport_token", "start_time"]
      msg[:response] = CodeHelper.CODE_MISSING_PARAMS(arr_params)
      msg[:description] = "需要提供longitude 和 latitude 位置信息 和 user id ,passport_token"
      render :json =>  msg.to_json
      return
    end

    checkUser = checkUserExistBeforeOperationStart(params[:user_id], msg)

    if checkUser

      userLocation = Location.new
      userLocation.latitude =  params[:latitude]
      userLocation.longitude =  params[:longitude]
      userLocation.content =  params[:content]
      start_date = Time.parse(params[:start_time])
      userLocation.start_date = start_date
      userLocation.user_id =  params[:user_id]

      if userLocation.save

        meetLocation = MeetLocation.new
        meetLocation.user_id =  params[:user_id]
        meetLocation.location_id =  userLocation.id

        if meetLocation.save

          msg[:response] =CodeHelper.CODE_SUCCESS
          msg[:location_id] = userLocation.user_id
          msg[:description] = "操作成功, 储存用户位置"
          render :json =>  msg
        else

          msg[:response] =CodeHelper.CODE_FAIL
          msg[:description] = "操作失败, 储存用户位置不成功"
          render :json =>  msg
        end

      else

        msg[:response] =CodeHelper.CODE_FAIL
        msg[:description] = "操作失败"
        render :json =>  msg
      end

    end
  end


  #@events = Event.where(:id => params[:event_id].to_i)
  ##@date = @events.first.start.localtime
  #elsif !params[:event_day].blank?
  #time = Time.at(params[:event_day].to_i).beginning_of_day
  #start_time = time + 1.day
  #@events = Event.where("sitemap_id in (?) and start < ? and end >= ?",@@sitemap_id,start_time,time).order("start")
  #@date = time

  api :GET, "/user/findMyTrip", "用户记录行程足迹"

  param :user_id, String, "用户 id", :required => true
  param :passport_token, String, "用户令牌，用于操作的身份验证", :required => true
  param :start_date_from, String, "用户足迹开始时间 e.g. 2014-07-04 17:52:16， 按天算，或者小时", :required => true
  param :to_end_date, String, "用户足迹结束时间 e.g. 2014-07-10 9:12:34", :required => true
  description <<-EOS


  EOS
  def findMyTrip

    msg = Hash.new

    #time1 = Time.parse(params[:start_date])
    #time2 = Time.parse(params[:end_date])
    #
    #date1 = Date.strptime(params[:start_date], '%Y-%m-%d %H:%M:%S')
    #date2 = Date.strptime(params[:end_date], '%Y-%m-%d %H:%M:%S')
    #
    #logger.info "convert #{date1} and #{date2}  /// \n original time1  #{time1}  to second #{time1.to_i}  and original time2 #{time2} to seconds #{time2.to_i} "
    #
    #logger.info "reverse date from seconds #{Time.at(time1.to_i)}  and time2 #{Time.at(time2.to_i)} "

    if params[:user_id].nil?  || params[:passport_token].nil?

      arr_params = [ "user_id" , "passport_token"]
      msg[:response] = CodeHelper.CODE_MISSING_PARAMS(arr_params)
      msg[:description] = "需要提供 user id, passport_token"
      render :json =>  msg.to_json
      return
    end

    checkUser = checkUserExistBeforeOperationStart(params[:user_id], msg)

    if checkUser

      myLocations = nil

      if !params[:start_date_from].nil? && !params[:to_end_date].nil?

        start_date = Time.parse(params[:start_date_from])
        end_date = Time.parse(params[:to_end_date])
        myLocations = User.find_by_id(params[:user_id]).locations.where("start_date >= ? and start_date <= ?",start_date,end_date).order("start_date")
      else

        myLocations = User.find_by_id(params[:user_id]).locations
      end

      if myLocations.nil?

        msg[:response] =CodeHelper.CODE_FAIL
        msg[:description] = "用户足迹返回失败"
        render :json =>  msg
      else

        msg[:response] =CodeHelper.CODE_SUCCESS
        msg[:description] = "用户足迹返回成功"
        msg[:locations] = myLocations
        render :json =>  msg
      end
    end
  end


  #api :POST, "/user/userMeets", "用户遇见"
  #
  #param :sender_id, String, "用户sender_id", :required => true
  #param :receiver_id, String, "用户receiver_id", :required => true
  #param :passport_token, String, "用户令牌，用于操作的身份验证", :required => true
  #
  #description <<-EOS


  #EOS
  api :GET, "/user/usersLocationMet", "返回同一时间段被记录的用户location"

  param :user_id, String, "用户 id", :required => true
  param :passport_token, String, "用户令牌，用于操作的身份验证", :required => true
  param :recorded_at, String, "用户的位置所被记录的时间， （确保被计算距离的用户，是处于同一时间点）. e.g 2014-07-10 9:12", :required => true
  description <<-EOS


  EOS
  def usersLocationMet

    msg = Hash.new

    #logger.info "get distance #{distance([46.3625, 15.114444],[46.055556, 14.508333])}"

    if params[:user_id].nil?   || params[:recorded_at].nil?  || params[:passport_token].nil?#|| params[:longitude].nil?  || params[:latitude].nil?

      arr_params = ["user_id", "recorded_at", "passport_token"]
      msg[:response] = CodeHelper.CODE_MISSING_PARAMS(arr_params)
      msg[:description] = "需要提供必要参数"
      render :json =>  msg.to_json
      return
    end

    checkUser = checkUserExistBeforeOperationStart(params[:user_id], msg)

    if checkUser

      meet_date = Time.parse(params[:recorded_at])
      meet_date_max = meet_date + 1.hour
      meet_date_min = meet_date - 1.hour

      userMetLocations = Location.where("user_id != ? and start_date > ?  and start_date < ?", params[:user_id], meet_date_min, meet_date_max)

      if userMetLocations.nil?

        msg[:response] =CodeHelper.CODE_FAIL
        msg[:userMet_Location] = ""
        msg[:description] = "用户偶遇对象返回失败"
        render :json =>  msg
        return
      else

        msg[:response] =CodeHelper.CODE_SUCCESS
        msg[:description] = "用户偶遇对象返回成功"
        msg[:userMet_Location] = userMetLocations
        render :json =>  msg
        return
      end

    end

  end

  api :GET, "/user/findSpecifcUsers", "根据 user  ids 返回一个或者多个用户信息 "

  param :user_id, String, "用户 id， 可以多个用,隔开  e.g. 1,2,3,4,5", :required => true
  param :passport_token, String, "用户令牌，用于操作的身份验证", :required => true
  description <<-EOS


  EOS
  def findSpecifcUsers

    msg = Hash.new

    #logger.info "get distance #{distance([46.3625, 15.114444],[46.055556, 14.508333])}"

    if params[:user_id].nil? || params[:passport_token].nil?#|| params[:longitude].nil?  || params[:latitude].nil?

      arr_params = ["user_id", "passport_token"]
      msg[:response] = CodeHelper.CODE_MISSING_PARAMS(arr_params)
      msg[:description] = "需要提供必要参数"
      render :json =>  msg.to_json
      return
    end

    userIds = params[:user_id].split(/,/)
    users = User.find_all_by_id(userIds)

    if users.count == 0

      msg[:response] = CodeHelper.CODE_FAIL
      msg[:description] = "返回用户信息失败"
      render :json =>  msg.to_json
      return

    else

      msg[:response] = CodeHelper.CODE_SUCCESS
      msg[:description] = "用户信息返回成功"
      msg[:users] = users
      render :json =>  msg.to_json
      return

    end

  end



end
