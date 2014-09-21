#encoding: UTF-8
class CommentController < ApplicationController
  protect_from_forgery

  def createComment

    msg = Hash.new

    if params[:event_id].nil? ||  params[:user_id].nil?  ||  params[:content].nil?

      arr_params = ["event_id", "user_id", "content"]
      msg[:response] = CodeHelper.CODE_MISSING_PARAMS(arr_params)
      msg[:description] = "请填写所需信息..."
      render :json =>  msg.to_json
      return
    end

    checkUser = checkUserExistBeforeOperationStart(params[:user_id], msg)

    if checkUser

      newComment = Comment.new
      newComment.event_id = params[:event_id]
      newComment.user_id = params[:user_id]
      newComment.content = params[:content]

      if newComment.save

        ownerEvent = Event.find_by_id(newComment.event_id)   #get the commented event
        push_user_owner = User.find_by_id(ownerEvent.user_id)            # get the event creator
        eloc = ELocation.where("event_id = ?", newComment.event_id).first         # get the event location

        dic_info = Hash.new
        dic_info[:event_id] =  newComment.event_id

        pushTest_development_for_comment(push_user_owner.uuid, "你的 时光胶囊(位于#{eloc.address}) 有了新的留言",dic_info)

        sendPushToOtherPassbys = Comment.find_by_sql("select *, count(user_id) from comments where event_id = #{newComment.event_id} group by user_id order by created_at desc")


        for passby in sendPushToOtherPassbys

          user_id = passby.user_id.to_i

          user =  User.where("id = ?", user_id).first

          if  user_id !=  ownerEvent.user_id.to_i && user.is_loggedin = "yes"

            pushTest_development_for_comment(user.uuid, "你曾经留言的时光胶囊 (位于#{eloc.address}) 有了新的留言", dic_info)
          end
        end

        #logger.info "push user_id #{push_user_owner.uuid}  and #{push_user_sender.uuid}"

        msg[:response] =CodeHelper.CODE_SUCCESS
        msg[:description] = "评论成功"
        render :json =>  msg
        return
      else

        msg[:response] =CodeHelper.CODE_FAIL
        msg[:description] = "评论失败"
        render :json =>  msg
        return
      end
    end
  end

  def  pushTest_development_for_comment(device_token,content, dic_info)


    logger.info "sending info to #{device_token} "
    certificateFile =  "certificate_meet_dev.pem"
    #content = params[:content].nil? ? "development environment testing":params[:content]
    certificate =   certificateFile
    devicetoken =   device_token
    environment = "development"
    pushNotification(certificate, devicetoken, environment, content, dic_info)
  end

  def deleteComment

    msg = Hash.new

    if params[:comment_id].nil? ||  params[:user_id].nil?  ||  params[:content].nil?

      arr_params = ["event_id", "user_id", "content"]
      msg[:response] = CodeHelper.CODE_MISSING_PARAMS(arr_params)
      msg[:description] = "请填写所需信息..."
      render :json =>  msg.to_json
      return
    end

    checkUser = checkUserExistBeforeOperationStart(params[:user_id], msg)

    if checkUser

      d_comment = Comment.find_by_id(params[:event_id])

      if d_comment

        if d_comment.delete

          msg[:response] =CodeHelper.CODE_SUCCESS
          msg[:description] = "删除成功"
          render :json =>  msg
          return
        else

          msg[:response] =CodeHelper.CODE_FAIL
          msg[:description] = "删除失败"
          render :json =>  msg
          return
        end
      else

        msg[:response] =CodeHelper.CODE_FAIL
        msg[:description] = "评论不存在"
        render :json =>  msg
        return
      end
    end
  end

  def updateComment


  end


  def listCommentsCount

    msg = Hash.new

    if params[:event_id].nil?
      arr_params = ["event_id"]
      msg[:response] = CodeHelper.CODE_MISSING_PARAMS(arr_params)
      msg[:description] = "请填写所需信息..."
      render :json =>  msg.to_json
      return
    end

    checkUser = checkUserExistBeforeOperationStart(params[:user_id], msg)

    if checkUser

      comments_count = Comment.count(:conditions => "event_id = #{params[:event_id]}")

      if comments_count != nil

        msg[:response] =CodeHelper.CODE_SUCCESS
        msg[:total_comment] =comments_count
        msg[:description] = "返回数量成功"
        render :json =>  msg
        return
      else

        msg[:response] =CodeHelper.CODE_FAIL
        msg[:comments] =""
        msg[:description] = "返回数量失败"
        render :json =>  msg
        return
      end
    end
  end

  def listComments

    msg = Hash.new

    if params[:event_id].nil?
      arr_params = ["event_id"]
      msg[:response] = CodeHelper.CODE_MISSING_PARAMS(arr_params)
      msg[:description] = "请填写所需信息..."
      render :json =>  msg.to_json
      return
    end

    checkUser = checkUserExistBeforeOperationStart(params[:user_id], msg)

    if checkUser

      comments = Comment.where("event_id = ?", params[:event_id]).order("created_at desc")

      if comments.count >  0

        msg[:response] =CodeHelper.CODE_SUCCESS

        if params[:limit_count].nil? || params[:limit_count].blank?  || params[:limit_count] == 0

          msg[:comments] =comments
        else

          arr_comments_to_sort = comments.limit(params[:limit_count].to_i)
          msg[:comments] = arr_comments_to_sort.reverse
        end

        msg[:total_count] = comments.count
        msg[:description] = "留言返回成功"
        render :json =>  msg
        return
      else

        msg[:response] =CodeHelper.CODE_FAIL
        msg[:comments] =""
        msg[:total_count] = 0
        msg[:description] = "还没有人评论"
        render :json =>  msg
        return
      end
    end
  end

end
