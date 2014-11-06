#encoding: UTF-8
class AdminController < ApplicationController
  protect_from_forgery



  def index

    if params[:userName] == "linguiwei" &&  params[:password] == "linguiwei"


      @user = User.all

    else

      render :inline =>  "server error"
    end
  end



  def adminSetting

    if  params[:user_id].nil? ||  params[:passport_token].nil?

      arr_params = [ "user_id", "passport_token"]
      msg[:response] = CodeHelper.CODE_MISSING_PARAMS(arr_params)
      msg[:description] = "请提供所需参数"
      render :json =>  msg.to_json
      return
    end

    msg = Hash.new
    msg[:response] =CodeHelper.CODE_ADMIN_OPEN
    render :json =>  msg
  end


  def getAllUsers

    msg = Hash.new

    if  params[:user_id].nil? ||  params[:passport_token].nil?

      arr_params = [ "user_id", "passport_token"]
      msg[:response] = CodeHelper.CODE_MISSING_PARAMS(arr_params)
      msg[:description] = "请提供所需参数"
      render :json =>  msg.to_json
      return
    end

    users = User.order("created_at desc").all

    users_Detail = Array.new

    for user in users

      user_dic = Hash.new
      user_dic[:id] = user.id
      user_dic[:nickname]  = user.nickname
      user_dic[:is_logged] = user.is_loggedin
      user_dic[:sex] = user.sex
      user_dic[:image_url] = user.avatar.url.to_s

      reportedCount = UserReport.find_by_sql("SELECT count(stranger_id) as reportedSum FROM user_reports WHERE user_id = #{user.id}").first

      user_dic[:reported_count] = reportedCount.reportedSum

      users_Detail << user_dic

    end

    msg[:response] =CodeHelper.CODE_ADMIN_OPEN
    msg[:users] = users_Detail

    render :json =>  msg

  end

end
