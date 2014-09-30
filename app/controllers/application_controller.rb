#encoding: UTF-8
class ApplicationController < ActionController::Base
  protect_from_forgery


  def  pushTest_development_for_comment(device_token,content, dic_info)


    logger.info "sending info to #{device_token} "
    certificateFile =  "certificate_dev.pem"
    #content = params[:content].nil? ? "development environment testing":params[:content]
    certificate =   certificateFile
    devicetoken =   device_token
    environment = "development"
    pushNotification(certificate, devicetoken, environment, content, dic_info)
  end

  def  pushTest_production_for_comment(device_token,content, dic_info)


    logger.info "sending info to pro #{device_token} "
    certificateFile =  "certificate_pro.pem"
    #content = params[:content].nil? ? "development environment testing":params[:content]
    certificate =   certificateFile
    devicetoken =   device_token
    environment = "production"
    pushNotification(certificate, devicetoken, environment, content, dic_info)
  end


  def pushNotification(certificate_name, device_token, env, content, dic_info)

    if env == "development"

      s_gateway = "gateway.sandbox.push.apple.com"
    else

      s_gateway = "gateway.push.apple.com"
    end

    logger.info "getting here???"

    pusher = Grocer.pusher(

        certificate: "#{Rails.root}/#{certificate_name}",      # required
        passphrase:  "",                       # optional
        gateway:     s_gateway, # optional; See note below. production..  gateway.push.apple.com
        port:        2195,                     # optional
        retries:     3                         # optional
    )

    notification = Grocer::Notification.new(

        device_token:      "#{device_token}",
        alert:             content,
        custom:            dic_info,
        badge:             1,
        sound:             "siren.aiff",         # optional
        expiry:            Time.now + 60*60,     # optional; 0 is default, meaning the message is not stored
        identifier:        1234,                 # optional
        content_available: true                  # optional; any truthy value will set 'content-available' to 1
    )

    pusher.push(notification)
  end



  def checkUserExistBeforeOperationStart(user_id, msg)

    user = User.find_by_id(user_id)

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
    end

    return true
  end
  def checkAndReturnUserExistBeforeOperationStart(user_id, msg)

    user = User.find_by_id(user_id)

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
    end

    return user
  end


  def checkIfInBlackList(user1, user2)

    blackUser = BlackList.where("(user_id = ? and stranger_id = ?) or (user_id = ? and stranger_id = ?)", user1, user2, user2, user1 ).first

    if  blackUser.nil?

      return false

    else
      return true
    end
  end


  #puts distance [46.3625, 15.114444],[46.055556, 14.508333]

  def distance(a, b)   # (latitude, longittude)

    rad_per_deg = Math::PI/180  # PI / 180
    rkm = 6371                  # Earth radius in kilometers
    rm = rkm * 1000             # Radius in meters

    dlon_rad = (b[1]-a[1]) * rad_per_deg  # Delta, converted to rad
    dlat_rad = (b[0]-a[0]) * rad_per_deg

    lat1_rad, lon1_rad = a.map! {|i| i * rad_per_deg }
    lat2_rad, lon2_rad = b.map! {|i| i * rad_per_deg }

    a = Math.sin(dlat_rad/2)**2 + Math.cos(lat1_rad) * Math.cos(lat2_rad) * Math.sin(dlon_rad/2)**2
    c = 2 * Math.asin(Math.sqrt(a))

    return rm * c # Delta in meters
  end



  ##每个location 有一数组用户，通过前台计算距离， 显示匹配用户。。。

  #CLLocation *locA = [[CLLocation alloc] initWithLatitude:lat1 longitude:long1];
  #
  #CLLocation *locB = [[CLLocation alloc] initWithLatitude:lat2 longitude:long2];
  #
  #CLLocationDistance distance = [locA distanceFromLocation:locB];
  #
  #//Distance in Meters
  #
  #//1 meter == 100 centimeter
  #
  #//1 meter == 3.280 feet
  #
  #//1 square meter == 10.76 square feet

end
