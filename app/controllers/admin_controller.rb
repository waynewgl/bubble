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
      user_dic[:account]  = user.account
      user_dic[:is_logged] = user.isLoggedin
      user_dic[:sex] = user.sex
      user_dic[:image_url] = user.avatar.url.to_s

      reportedCount = UserReport.find_by_sql("SELECT count(stranger_id) as reportedSum FROM user_reports WHERE stranger_id = #{user.id}").first

      user_dic[:reported_count] = reportedCount.reportedSum

      users_Detail << user_dic

    end

    msg[:response] =CodeHelper.CODE_SUCCESS
    msg[:users] = users_Detail

    render :json =>  msg

  end


  def deleteUser

    if  params[:user_id].nil?   || params[:passport_token].nil? || params[:delete_user_id].nil?
      arr_params = [ "user_id", "passport_token"]
      msg[:response] = CodeHelper.CODE_MISSING_PARAMS(arr_params)
      msg[:description] = "需要提供 user id ,passport_token"
      render :json =>  msg.to_json
      return
    end

    msg = Hash.new

    if params[:auth_code] == "linguiwei19870707"

      deleteUser = User.find_by_id(params[:delete_user_id])

      deleteEvents = Event.where("user_id = ?", params[:delete_user_id])

      if deleteEvents.count > 0

        for event in deleteEvents

          if  !event.event_images.nil?  && event.event_images.count > 0

            for img in  event.event_images

              img = nil
            end

            event.event_images.destroy_all()
          end

          if  !event.comments.nil?

            event.comments.destroy_all()
          end

          if  !event.e_location.nil?

            event.e_location.delete
          end

          if  !event.report_events.nil?

            event.report_events.destroy_all()
          end

        end

      end

      if !deleteUser.nil?

        userCommentDelete = Comment.where("user_id = ?", deleteUser.id)

        if userCommentDelete.count > 0

          userCommentDelete.destroy_all()
        end

        meetGroupDelete = MeetGroup.where("user_id = ? or stranger_id = ?", deleteUser.id, deleteUser.id)

        if meetGroupDelete.count > 0

          meetGroupDelete.destroy_all()
        end
      end

      if deleteEvents.destroy_all() && deleteUser.delete

        msg[:response] = CodeHelper.CODE_SUCCESS
        render :json =>  msg.to_json
        return
      else

        msg[:response] = CodeHelper.CODE_FAIL
        render :json =>  msg.to_json
        return
      end

    else

      arr_params = [ "code"]
      msg[:response] = CodeHelper.CODE_MISSING_PARAMS(arr_params)
      msg[:description] = "需要提供授权码"
      render :json =>  msg.to_json
      return
    end

  end

end
