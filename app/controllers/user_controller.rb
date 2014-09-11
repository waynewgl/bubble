#encoding: UTF-8
class UserController < ApplicationController
  protect_from_forgery
  include CodeHelper

  def index


  end


  def checkUpdate

    msg = Hash.new

    if  params[:user_id].nil?   || params[:passport_token].nil?
      arr_params = [ "user_id", "passport_token"]
      msg[:response] = CodeHelper.CODE_MISSING_PARAMS(arr_params)
      msg[:description] = "需要提供 user id ,passport_token"
      render :json =>  msg.to_json
      return
    end

    checkUser = checkUserExistBeforeOperationStart(params[:user_id], msg)

    if checkUser

      msg[:response] = CodeHelper.CODE_SUCCESS
      msg[:version] = 1.0
      msg[:trackUrl] = "http://itunes.apple.com/"
      render :json =>  msg.to_json
    end

  end


  def getUserBlackList

    msg = Hash.new

    if  params[:user_id].nil?   || params[:passport_token].nil?
      arr_params = [ "user_id", "passport_token"]
      msg[:response] = CodeHelper.CODE_MISSING_PARAMS(arr_params)
      msg[:description] = "需要提供 user id ,passport_token"
      render :json =>  msg.to_json
      return
    end

    checkUser = checkUserExistBeforeOperationStart(params[:user_id], msg)

    if checkUser

      blackLists = BlackList.where("user_id = ?", params[:user_id])

      if blackLists.nil?

        msg[:response] = CodeHelper.CODE_FAIL
        msg[:description] = "返回成功."
        msg[:blackLists] = ""
        render :json =>  msg.to_json
      else

        msg[:response] = CodeHelper.CODE_SUCCESS
        msg[:description] = "返回成功."
        msg[:blackLists] = blackLists
        render :json =>  msg.to_json
      end
    end

  end


  def removeSpecificBlackList

    msg = Hash.new

    if  params[:user_id].nil? || params[:stranger_id].nil?    || params[:passport_token].nil?
      arr_params = [ "user_id","stranger_id",  "passport_token"]
      msg[:response] = CodeHelper.CODE_MISSING_PARAMS(arr_params)
      msg[:description] = "需要提供 user id ,passport_token, stranger_id"
      render :json =>  msg.to_json
      return
    end

    checkUser = checkUserExistBeforeOperationStart(params[:user_id], msg)

    if checkUser

         removeBlackList = BlackList.where("user_id = ? && stranger_id = ?", params[:user_id], params[:stranger_id]).first

        if removeBlackList.delete

          msg[:response] = CodeHelper.CODE_SUCCESS
          msg[:description] = "移除黑名单成功."
          render :json =>  msg.to_json
          return
        else

          msg[:response] = CodeHelper.CODE_SUCCESS
          msg[:description] = "移除黑名单失败."
          render :json =>  msg.to_json
          return
        end

    end
  end

  def getReportReasons

    msg = Hash.new

    if  params[:user_id].nil?   || params[:passport_token].nil?
      arr_params = [ "user_id", "passport_token"]
      msg[:response] = CodeHelper.CODE_MISSING_PARAMS(arr_params)
      msg[:description] = "需要提供 user id ,passport_token"
      render :json =>  msg.to_json
      return
    end

    checkUser = checkUserExistBeforeOperationStart(params[:user_id], msg)

    if checkUser

      arr_report_reason = ["垃圾营销","淫秽色情","骚扰信息","人身攻击","敏感信息", "泄露隐私"]

      msg[:response] = CodeHelper.CODE_SUCCESS
      msg[:description] = "返回成功."
      msg[:reasons] = arr_report_reason
      render :json =>  msg.to_json
      return
    end
  end


  def restorePassword

    msg = Hash.new

    if  params[:account].nil?

      arr_params = ["account"]
      msg[:response] = CodeHelper.CODE_MISSING_PARAMS(arr_params)
      msg[:description] = "请填写所需参数..."
      render :json =>  msg.to_json
      return
    end


    @user = User.where("account = ?", params[:account]).first

    if @user.nil?

      msg[:response] = CodeHelper.CODE_FAIL
      msg[:description] = "返回密码失败,邮箱不正确"
      render :json =>  msg.to_json
      return
    else

      UserMailer.confirm(@user, "返回密码").deliver
      msg[:response] = CodeHelper.CODE_SUCCESS
      msg[:description] = "已经返回密码到你的邮箱，请查看"
      render :json =>  msg.to_json
      return
    end
  end


  def changePassword

    msg = Hash.new

    if params[:password].nil? ||  params[:user_id].nil? || params[:passport_token].nil?

      arr_params = ["event_id", "user_id", "passport token"]
      msg[:response] = CodeHelper.CODE_MISSING_PARAMS(arr_params)
      msg[:description] = "请填写所需参数..."
      render :json =>  msg.to_json
      return
    end


    checkUser = checkUserExistBeforeOperationStart(params[:user_id], msg)

    if checkUser

      user = User.find_by_id(params[:user_id])
      user.password = Digest::SHA1.hexdigest(params[:password])

      if user.save

        msg[:response] = CodeHelper.CODE_SUCCESS
        msg[:description] = "修改密码成功"
        render :json =>  msg.to_json
        return
      else

        msg[:response] = CodeHelper.CODE_FAIL
        msg[:description] = "修改密码失败"
        render :json =>  msg.to_json
        return
      end
    end
  end




  def reportUser

    msg = Hash.new

    if params[:stranger_id].nil? ||  params[:user_id].nil? ||  params[:reason].nil?  || params[:passport_token].nil?

      arr_params = ["stranger_id", "user_id", "reason", "passport token"]
      msg[:response] = CodeHelper.CODE_MISSING_PARAMS(arr_params)
      msg[:description] = "请填写所需参数..."
      render :json =>  msg.to_json
      return
    else

      checkUser = checkUserExistBeforeOperationStart(params[:user_id], msg)

      if checkUser

        reportUser = UserReport.where("stranger_id = ? && user_id = ?", params[:stranger_id], params[:user_id]).first

        if !reportUser.nil?

          msg[:response] = CodeHelper.CODE_REPORT_REPEAT
          msg[:description] = "你已经举报过了"
          render :json =>  msg.to_json
          return
        end

        reportUser = UserReport.new
        reportUser.stranger_id = params[:stranger_id]
        reportUser.user_id = params[:user_id]
        reportUser.reason = params[:reason]

        if reportUser.save

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


  def blackList

    msg = Hash.new

    if params[:stranger_id].nil? ||  params[:user_id].nil? || params[:passport_token].nil?

      arr_params = ["stranger_id", "user_id", "passport token"]
      msg[:response] = CodeHelper.CODE_MISSING_PARAMS(arr_params)
      msg[:description] = "请填写所需参数..."
      render :json =>  msg.to_json
      return
    else

      checkUser = checkUserExistBeforeOperationStart(params[:user_id], msg)

      if checkUser

        userBlackList = BlackList.where("stranger_id = ? && user_id = ?", params[:stranger_id], params[:user_id]).first
        if !userBlackList.nil?

          msg[:response] = CodeHelper.CODE_REPORT_REPEAT
          msg[:description] = "你已经添加过该用户"
          render :json =>  msg.to_json
          return
        end

        userBlackList = BlackList.new
        userBlackList.stranger_id = params[:stranger_id]
        userBlackList.user_id = params[:user_id]

        if userBlackList.save

          msg[:response] = CodeHelper.CODE_SUCCESS
          msg[:description] = "已添加黑名单"
          render :json =>  msg.to_json
          return

        else
          msg[:response] = CodeHelper.CODE_FAIL
          msg[:description] = "添加黑名单失败"
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

    user = User.where("account = ?", params[:account] ).first

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
        return
      else

        msg[:response] = CodeHelper.CODE_FAIL
        msg[:description] = "用户注册失败"
        render :json =>  msg.to_json
        return
      end
    else

      msg[:response] = CodeHelper.CODE_FAIL
      msg[:description] = "该用户已经存在，请重新选用其他账号注册"
      render :json =>  msg.to_json
      return
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

    user = User.where("account = ? and password = ?", params[:account], Digest::SHA1.hexdigest(params[:password]) ).first

    if user.nil?

      msg[:response] = CodeHelper.CODE_USER_NOT_EXIST
      msg[:user] = ""
      msg[:description] = "登陆失败，密码或者用户名错误"
      render :json =>  msg.to_json
      return
    else
      #
      #if user.is_loggedin == "yes"
      #
      #  logger.info "what happended??? #{user.is_loggedin}"
      #
      #  msg[:response] = CodeHelper.CODE_USER_LOGGED_IN
      #  msg[:user] = ""
      #  msg[:description] = "登陆失败， 用户已经登陆"
      #  render :json =>  msg.to_json
      #  return
      #
      #else

        msg[:response] = CodeHelper.CODE_SUCCESS
        user.passport_token = nil
        msg[:passport_token] =  user.generate_token
        user.update_attribute(:passport_token, msg[:passport_token] )
        user.update_attribute("is_loggedin", "yes")
        msg[:user] = user
        msg[:description] = "登陆成功"
        render :json =>  msg.to_json
        return
      #end

    end

  end

  api :GET, "/user/userLogout", "用户登出"

  param :user_id, String, "用户id", :required => true
  param :passport_token, String, "用户操作授权码", :required => true

  description <<-EOS


  EOS
  def userLogout

    msg = Hash.new

    if params[:user_id].nil? ||  params[:passport_token].nil?

      arr_params = ["user_id", "passport_token"]
      msg[:response] = CodeHelper.CODE_MISSING_PARAMS(arr_params)
      msg[:description] = "请提供所需信息..."
      render :json =>  msg.to_json
      return
    end

    user = User.find_by_id(params[:user_id])

    if user.nil?

      msg[:response] = CodeHelper.CODE_FAIL
      msg[:user] = ""
      msg[:description] = "操作失败"
      render :json =>  msg.to_json
      return
    else

      user.update_attribute("is_loggedin", "no")
      msg[:response] = CodeHelper.CODE_SUCCESS
      msg[:description] = "用户退出成功"
      render :json =>  msg.to_json
      return
    end

  end



  api :POST, "/user/updateUserDetail", "用户上传头像"

  param :user_id, String, "用户id", :required => true
  param :nickName, String, "用户nick name", :required => false
  param :email, String, "用户email", :required => false
  param :sex, String, "用户sex", :required => false
  param :passport_token, String, "用户令牌，用于操作的身份验证", :required => true

  description <<-EOS

  EOS


  def  updateUserDetail

    msg = Hash.new

    checkUpdatingUser = checkAndReturnUserExistBeforeOperationStart(params[:user_id], msg)

    checkUpdatingUser.nickname = params[:nickName]
    checkUpdatingUser.email = params[:email]
    checkUpdatingUser.sex = params[:sex]
    checkUpdatingUser.dob = params[:age]

    if !params[:avatar].nil?

      checkUpdatingUser.update_attributes(:avatar => params[:avatar])
    end

    if checkUpdatingUser.save

      msg[:response] =CodeHelper.CODE_SUCCESS
      msg[:description] = "更新成功"
      render :json =>  msg
      return
    else

      msg[:response] =CodeHelper.CODE_FAIL
      msg[:description] = "更新失败"
      render :json =>  msg
      return
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
          return
        else

          msg[:response] =CodeHelper.CODE_FAIL
          msg[:description] = "操作失败, 储存用户位置不成功"
          render :json =>  msg
          return
        end

      else

        msg[:response] =CodeHelper.CODE_FAIL
        msg[:description] = "操作失败"
        render :json =>  msg
        return
      end

    end
  end



  def getLatestLocation

    msg = Hash.new

    if params[:user_id].nil?   || params[:passport_token].nil?
      arr_params = [ "user_id", "passport_token"]
      msg[:response] = CodeHelper.CODE_MISSING_PARAMS(arr_params)
      msg[:description] = "需要提供 user id ,passport_token"
      render :json =>  msg.to_json
      return
    end

    loc = Location.where("user_id = ?", params[:user_id]).first

    if !loc.nil?

      msg[:response] =CodeHelper.CODE_SUCCESS
      msg[:location] = loc
      msg[:description] = "操作成功, 返回用户位置"
      render :json =>  msg
      return
    else

      msg[:response] =CodeHelper.CODE_FAIL
      msg[:location] = ""
      msg[:description] = "操作失败, 返回用户位置失败"
      render :json =>  msg
      return
    end

  end

  api :POST, "/user/recordUserLocation", "用户更新位置信息, 一个用户只有一个唯一位置"

  param :longitude, String, "用户位置longitude", :required => true
  param :latitude, String, "用户位置latitude", :required => true
  param :start_time, String, "用户位置记录时间", :required => true
  param :user_id, String, "用户 id", :required => true
  param :passport_token, String, "用户令牌，用于操作的身份验证", :required => true

  description <<-EOS


  EOS
  def recordUserLocation

    logger.info "do we get format  date #{Date.parse(params[:start_time])}  and time  #{Time.parse(params[:start_time])}  "

    msg = Hash.new

    if params[:longitude].nil? || params[:latitude].nil?  || params[:user_id].nil?   || params[:passport_token].nil?   || params[:start_time].nil?
      arr_params = ["longitude", "latitude", "user_id", "passport_token", "start_time"]
      msg[:response] = CodeHelper.CODE_MISSING_PARAMS(arr_params)
      msg[:description] = "需要提供longitude 和 latitude 位置信息 和 user id ,passport_token"
      render :json =>  msg.to_json
      return
    end

    checkUser = checkAndReturnUserExistBeforeOperationStart(params[:user_id], msg)

    if !checkUser.nil?

      if checkUser.location.nil?

        userLocation = Location.new
      else

        userLocation = checkUser.location
      end

      userLocation.latitude =  params[:latitude]
      userLocation.longitude =  params[:longitude]
      userLocation.content =  params[:content]
      start_date = Time.parse(params[:start_time])
      userLocation.start_date = start_date
      userLocation.user_id =  params[:user_id]

      if userLocation.save

        msg[:response] =CodeHelper.CODE_SUCCESS
        msg[:location_id] = userLocation.id
        msg[:location_address] = userLocation.content
        msg[:description] = "操作成功, 储存用户位置"
        render :json =>  msg
        return
      else

        msg[:response] =CodeHelper.CODE_FAIL
        msg[:description] = "操作失败, 储存用户位置不成功"
        render :json =>  msg
        return
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
        return
      else

        msg[:response] =CodeHelper.CODE_SUCCESS
        msg[:description] = "用户足迹返回成功"
        msg[:locations] = myLocations
        render :json =>  msg
        return
      end
    end
  end



  #EOS
  api :GET, "/user/addUsersMeetLocation", "添加用户周边遇到的用户"

  param :user_id, String, "用户 id", :required => true
  param :stranger_id, String, "遇见的用户 id", :required => true
  param :address, String, "遇见的用户位置地址", :required => true
  param :passport_token, String, "用户令牌，用于操作的身份验证", :required => true
  param :meet_time, String, "用户的位置所被记录的时间， （确保被计算距离的用户，是处于同一时间点）. e.g 2014-07-10 9:12", :required => true
  description <<-EOS


  EOS
  def addUsersMeetLocation

    msg = Hash.new

    #logger.info "get distance #{distance([46.3625, 15.114444],[46.055556, 14.508333])}"

    if params[:user_id].nil?  || params[:stranger_id].nil? || params[:address].nil? ||  params[:meet_time].nil?  || params[:passport_token].nil?#|| params[:longitude].nil?  || params[:latitude].nil?

      arr_params = ["user_id", "stranger_id", "meet_time", "address",  "passport_token"]
      msg[:response] = CodeHelper.CODE_MISSING_PARAMS(arr_params)
      msg[:description] = "需要提供必要参数"
      render :json =>  msg.to_json
      return
    end

    isAddingNewMeet = false

    checkUser = checkUserExistBeforeOperationStart(params[:user_id], msg)

    if checkUser

      #meet_date = Time.parse(params[:recorded_at])
      #meet_date_max = meet_date + 0.5.hour
      #meet_date_min = meet_date - 0.5.hour
      meet_date  = Date.parse(params[:meet_time])
      current_date = Date.today
      #checkUsersExist = MeetGroup.where("user_id = ? and stranger_id = ? and Date(meet_time) = ?", params[:user_id], params[:stranger_id], params[:stranger_id]).first

      #检查是否已经存在地址一样的记录
      checkUsersExist = MeetGroup.where("user_id = ? and stranger_id = ? and address = ? and meet_time >= ?", params[:user_id], params[:stranger_id], params[:address], current_date).first

      if !checkUsersExist.nil?

        logger.info "meeting time from request #{meet_date} compare to  database meet time  #{checkUsersExist.meet_time.to_date} and current date #{current_date}"

        #比较该记录是否处于当天， 如果是，则忽略 ， 如果不是， 添加记录
        if  meet_date != checkUsersExist.meet_time.to_date   #如果两用户已经当天遇到过一次

          isAddingNewMeet = true
        else
          isAddingNewMeet = false
        end
      else

        isAddingNewMeet = true
      end

      if isAddingNewMeet

        checkUsersExist =  MeetGroup.new
        checkUsersExist.user_id =  params[:user_id]
        checkUsersExist.stranger_id =  params[:stranger_id]
        checkUsersExist.address =  params[:address]
        checkUsersExist.meet_time =  Time.parse(params[:meet_time]).localtime

        if checkUsersExist.save

          msg[:response] =CodeHelper.CODE_SUCCESS
          msg[:description] = "用户偶遇成功"
          msg[:userMet_Location] = checkUsersExist.id
          render :json =>  msg
          return
        else

          msg[:response] =CodeHelper.CODE_FAIL
          msg[:description] = "用户偶遇操作失误"
          render :json =>  msg
          return
        end
      else

        msg[:response] =CodeHelper.CODE_FAIL
        msg[:description] = "用户已经在这位置偶遇过"
        render :json =>  msg
        return
      end
    end
  end


  api :GET, "/user/usersLocationMet", "返回同一时间段内在活动的用户location"

  param :user_id, String, "用户 id", :required => true
  param :passport_token, String, "用户令牌，用于操作的身份验证", :required => true
  param :current_time, String, "用户的位置所被记录的时间， （确保被计算距离的用户，是处于同一时间点）. e.g 2014-07-10 9:12", :required => true
  description <<-EOS


  EOS
  def usersLocationMet

    msg = Hash.new

    #logger.info "get distance #{distance([46.3625, 15.114444],[46.055556, 14.508333])}"

    if params[:user_id].nil? || params[:passport_token].nil? || params[:current_time].nil?

      arr_params = ["user_id", "passport_token", "current_time"]
      msg[:response] = CodeHelper.CODE_MISSING_PARAMS(arr_params)
      msg[:description] = "需要提供必要参数"
      render :json =>  msg.to_json
      return
    end

    currentTime =  Time.parse(params[:current_time]).localtime
    time_from  = currentTime - 0.5.hour
    time_to  = currentTime + 0.5.hour

    usersAround = Location.where("user_id != ?  and start_date >= ?  and start_date <= ? ", params[:user_id], time_from, time_to)

    if usersAround.nil?

      msg[:response] = CodeHelper.CODE_FAIL
      msg[:description] = "没有周边用户"
      msg[:userMet_Location] = ""
      render :json =>  msg.to_json
      return

    else

      filter_userAround = Array.new

      for lo in usersAround

        if lo.user.is_loggedin == "yes"

          filter_userAround << lo
        end
      end

      msg[:response] = CodeHelper.CODE_SUCCESS
      msg[:description] = "看看你遇到了谁"
      msg[:userMet_Location] = filter_userAround
      render :json =>  msg.to_json
      return
    end

  end


  def userMeetStrangers

      msg = Hash.new

      #logger.info "get distance #{distance([46.3625, 15.114444],[46.055556, 14.508333])}"

      checkUser = checkUserExistBeforeOperationStart(params[:user_id], msg)

      if checkUser

        usersMeetDistinct = MeetGroup.find_by_sql("SELECT *, count(stranger_id) as total_meet  FROM meet_groups WHERE user_id = #{params[:user_id]} GROUP BY user_id, stranger_id ORDER BY meet_time desc")

        if usersMeetDistinct.nil?

          msg[:response] = CodeHelper.CODE_FAIL
          msg[:description] = "你还没偶遇过谁"
          msg[:users] = ""
          render :json =>  msg.to_json
          return
        else

          usersMeets = Array.new

          for userGroup in usersMeetDistinct

            dic_user = Hash.new
            dic_user[:user_id] = userGroup.user_id
            dic_user[:stranger_id] = userGroup.stranger_id
            dic_user[:address] = userGroup.address

            user = User.where("id = ?", userGroup.stranger_id).first

            userBlackList = BlackList.where("(stranger_id = ? && user_id = ?) or (stranger_id = ? && user_id = ?)", userGroup.stranger_id, userGroup.user_id, userGroup.user_id, userGroup.stranger_id).first

            if user.nil?

              dic_user[:stranger] = ""
            else

              dic_user[:stranger] = user
            end

            dic_user[:total_meet] = userGroup.total_meet
            dic_user[:first_meet] = userGroup.meet_time.localtime

            userMeetAddress = MeetGroup.find_by_sql("SELECT *, count(stranger_id) as total_meet  FROM meet_groups WHERE user_id = #{userGroup.user_id} and stranger_id = #{userGroup.stranger_id} GROUP BY address, stranger_id ORDER BY meet_time asc")

            if  userMeetAddress.nil?

              dic_user[:user_address_meet] = ""
            else

              dic_user[:user_address_meet] = userMeetAddress
            end

            if userBlackList.nil?

              usersMeets <<  dic_user
            end
          end

          msg[:response] = CodeHelper.CODE_SUCCESS
          msg[:description] = "返回偶遇对象"
          msg[:users] = usersMeets
          render :json =>  msg.to_json
          return
        end
      end
    end



  api :GET, "/user/historyOfUsersMeet", "返回指定用户遇到的人"

  param :user_id, String, "用户 id， 可以多个用,隔开  e.g. 1,2,3,4,5", :required => true
  param :passport_token, String, "用户令牌，用于操作的身份验证", :required => true
  description <<-EOS


  EOS
  def historyOfUsersMeet

    msg = Hash.new

    #logger.info "get distance #{distance([46.3625, 15.114444],[46.055556, 14.508333])}"

    if params[:user_id].nil? || params[:passport_token].nil?#|| params[:longitude].nil?  || params[:latitude].nil?

      arr_params = ["user_id", "passport_token"]
      msg[:response] = CodeHelper.CODE_MISSING_PARAMS(arr_params)
      msg[:description] = "需要提供必要参数"
      render :json =>  msg.to_json
      return
    end

    checkUser = checkUserExistBeforeOperationStart(params[:user_id], msg)

    if checkUser

      #meetUsersGroup = MeetGroup.where("user_id = ?", params[:user_id]).order("meet_time desc").group("meet_time")

      meetUsersGroup = MeetGroup.find_by_sql("SELECT *, count(stranger_id) as total_meet  FROM meet_groups WHERE user_id = #{params[:user_id]} GROUP BY stranger_id,address ORDER BY meet_time desc")

      #meetUserGroupDateDay = MeetGroup.find_by_sql("select DISTINCT meet_time from meet_groups GROUP BY day(meet_time) order by day(meet_time) desc")

      if meetUsersGroup.nil?

        msg[:response] = CodeHelper.CODE_FAIL
        msg[:description] = "你还没偶遇过谁"
        msg[:users] = ""
        render :json =>  msg.to_json
        return
      else

        arr_users = Array.new

        for userGroup in  meetUsersGroup

          dic_user = Hash.new

          user = User.where("id = ?", userGroup.stranger_id).first
          dic_user[:user] = user

          if  !userGroup.address.nil? && userGroup.address != "(null)"

            dic_user[:meet_address] =  userGroup.address
            dic_user[:meet_time_month] =  userGroup.meet_time.localtime.strftime("%Y-%m-%d")
            dic_user[:meet_time_hour] =  userGroup.meet_time.localtime.strftime('%H:%M')
            dic_user[:meet_time] =  userGroup.meet_time.localtime
            dic_user[:total_meet] =  userGroup.total_meet

            userBlackList = BlackList.where("(stranger_id = ? && user_id = ?) or (stranger_id = ? && user_id = ?)", userGroup.stranger_id, userGroup.user_id, userGroup.user_id, userGroup.stranger_id).first

            if userBlackList.nil? &&  !user.nil?

              arr_users <<  dic_user
            end
          end
        end

        msg[:response] = CodeHelper.CODE_SUCCESS
        msg[:description] = "返回偶遇用户"
        msg[:users] = arr_users
        render :json =>  msg.to_json
        return
      end
    end
  end

end
