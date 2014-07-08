#encoding: UTF-8
class EventController < ApplicationController
  protect_from_forgery

  api :POST, "/event/createEvent", "用户添加event,心情 etc"

  param :category_id, String, "用户event catetory, 1为心情， 2, 时光胶囊", :required => true
  param :title, String, "用户 event title", :required => true
  param :content, String, "用户 event content", :required => true
  param :post_time, String, "用户event 创建时间", :required => true
  param :user_id, String, "用户 id", :required => true
  param :passport_token, String, "用户令牌，用于操作的身份验证", :required => true

  description <<-EOS


  EOS
  def createEvent

    msg = Hash.new

    if params[:category_id].nil? ||  params[:title].nil?  ||  params[:content].nil? ||  params[:post_time].nil?  ||  params[:user_id].nil? ||  params[:passport_token].nil?

      arr_params = ["category_id", "title", "content", "post_time", "user_id", "passport_token"]
      msg[:response] = CodeHelper.CODE_MISSING_PARAMS(arr_params)
      msg[:description] = "请提供所需参数"
      render :json =>  msg.to_json
      return
    end

    checkUser = checkUserExistBeforeOperationStart(params[:user_id], msg)

    if checkUser

      event = Event.new
      event.user_id = params[:user_id]
      event.category_id = params[:category_id]
      event.title = params[:title]
      event.content = params[:content]
      event.post_time = params[:post_time]

      if event.save

        msg[:response] =CodeHelper.CODE_SUCCESS
        msg[:description] = "用户添加event成功"
        render :json =>  msg
        return
      else

        msg[:response] =CodeHelper.CODE_FAIL
        msg[:description] = "用户添加event失败"
        render :json =>  msg
        return
      end

    end
  end

  api :POST, "/event/deleteEvent", "用户删除event"

  param :event_id, String, "用户event id", :required => true
  param :user_id, String, "用户 id", :required => true
  param :passport_token, String, "用户令牌，用于操作的身份验证", :required => true

  description <<-EOS


  EOS
  def deleteEvent

    msg = Hash.new

    if params[:event_id].nil? ||  params[:user_id].nil? ||  params[:passport_token].nil?

      arr_params = ["event_id", "user_id", "passport_token"]
      msg[:response] = CodeHelper.CODE_MISSING_PARAMS(arr_params)
      msg[:description] = "请提供所需参数"
      render :json =>  msg.to_json
      return
    end

    checkUser = checkUserExistBeforeOperationStart(params[:user_id], msg)

    if checkUser

      event_tobe_deleted = Event.find_by_id(params[:event_id])

      if event_tobe_deleted.nil?

        msg[:response] = CodeHelper.CODE_FAIL
        msg[:description] = "该event不存在"
        render :json =>  msg.to_json
        return
      else

        if params[:user_id] != event_tobe_deleted.user_id

          msg[:response] = CodeHelper.CODE_FAIL
          msg[:description] = "删除event失败，你不是该event的创建者"
          render :json =>  msg.to_json
          return
        end

        event_tobe_deleted.event_images.update_attributes(:image => nil)
        event_tobe_deleted.event_images.destroy_all()
        event_tobe_deleted.event_locations.destroy_all()
        event_tobe_deleted.report_events.destroy_all()
        event_tobe_deleted.delete

        msg[:response] = CodeHelper.CODE_SUCCESS
        msg[:description] = "删除event成功"
        render :json =>  msg.to_json
        return

      end
    end
  end


  api :POST, "/event/uploadEventImage", "用户添加event image"

  param :event_id, String, "用户event id", :required => true
  param :user_id, String, "用户 id", :required => true
  param :image, String, "用户上传的图像data", :required => true
  param :passport_token, String, "用户令牌，用于操作的身份验证", :required => true

  description <<-EOS


  EOS
  def uploadEventImage

    msg = Hash.new
    if params[:event_id].nil? || params[:event_id].blank?

      arr_params = ["event_id"]
      msg[:response] = CodeHelper.CODE_MISSING_PARAMS(arr_params)
      msg[:description] = "缺失 event id "
      render :json =>  msg
      return
    end

    if params[:user_id].nil? || params[:user_id].blank?

      msg[:response] = CodeHelper.CODE_MISSING_PARAMS_USER_ID
      msg[:description] = "缺失 user id "
      render :json =>  msg
      return
    end

    checkUser = checkUserExistBeforeOperationStart(params[:user_id], msg)

    if checkUser

      event = Event.find_by_id(params[:event_id])

      if event.nil?

        msg[:response] =CodeHelper.CODE_FAIL
        msg[:description] = "该event不存在"
        render :json =>  msg
        return
      end


      if params[:image].nil? || params[:image].blank?

        arr_params = ["image"]
        msg[:response] = CodeHelper.CODE_MISSING_PARAMS(arr_params)
        msg[:description] = "请上传图片"
        render :json =>  msg
        return
      else

        eventImage = EventImage.new
        eventImage.event_id = params[:event_id]
        eventImage.update_attributes(:image => params[:image])
        eventImage.width = params[:width]
        eventImage.height = params[:height]

        if eventImage.save

          msg[:response] = CodeHelper.CODE_SUCCESS
          msg[:id]= eventImage.id
          msg[:description] = "上传成功"
          render :json =>  msg
          return
        end
      end

    end
  end

  api :POST, "/event/deleteEventImage", "删除某个event image"

  param :event_id, String, "用户event id", :required => true
  param :event_image_id, String, "用户event image id", :required => true
  param :user_id, String, "用户 id", :required => true
  param :passport_token, String, "用户令牌，用于操作的身份验证", :required => true

  description <<-EOS


  EOS
  def deleteEventImage

    if params[:event_id].nil? || params[:event_id].blank? || params[:event_image_id].blank? || params[:passport_token].blank?

      arr_params = ["event_id", "event_image_id", "passport_token"]
      msg[:response] = CodeHelper.CODE_MISSING_PARAMS(arr_params)
      msg[:description] = "缺失必要参数 "
      render :json =>  msg
      return
    end

    if params[:user_id].nil? || params[:user_id].blank?

      msg[:response] = CodeHelper.CODE_MISSING_PARAMS_USER_ID
      msg[:description] = "缺失 user id "
      render :json =>  msg
      return
    end

    checkUser = checkUserExistBeforeOperationStart(params[:user_id], msg)

    if checkUser

      event = Event.find_by_id(params[:event_id])

      if event.nil?

        msg[:response] =CodeHelper.CODE_FAIL
        msg[:description] = "该event不存在"
        render :json =>  msg
        return
      end

      eventImage = event.event_images.where(:id => (params[:event_image_id])).first

      if eventImage.nil?

        msg[:response] =CodeHelper.CODE_FAIL
        msg[:description] = "该event image不存在"
        render :json =>  msg
        return
      end

      eventImage.update_attributes(:image => nil)

      if eventImage.delete

        msg[:response] =CodeHelper.CODE_SUCCESS
        msg[:description] = "用户删除event image成功"
        render :json =>  msg
        return
      else

        msg[:response] =CodeHelper.CODE_FAIL
        msg[:description] = "用户删除event image 失败"
        render :json =>  msg
        return
      end

    end
  end


  def updateEvent



  end

end
