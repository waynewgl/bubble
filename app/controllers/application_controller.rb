#encoding: UTF-8
class ApplicationController < ActionController::Base
  protect_from_forgery



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
