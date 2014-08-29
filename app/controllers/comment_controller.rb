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

      comments = Comment.where("event_id = ?", params[:event_id]).order("created_at asc")

      if comments.count >  0

        msg[:response] =CodeHelper.CODE_SUCCESS
        msg[:comments] =comments
        msg[:description] = "留言返回成功"
        render :json =>  msg
        return
      else

        msg[:response] =CodeHelper.CODE_FAIL
        msg[:comments] =""
        msg[:description] = "还没有人评论"
        render :json =>  msg
        return
      end
    end
  end

end
