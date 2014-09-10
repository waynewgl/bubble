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
  param :image, Data, "图片数据", :required => false
  param :image_width, String, "图片宽度", :required => false
  param :image_height, String, "图片高度", :required => false

  description <<-EOS


  EOS
  def createEvent

    msg = Hash.new

    if   params[:content].nil? ||  params[:post_time].nil?  ||  params[:user_id].nil? ||  params[:passport_token].nil?

      arr_params = [ "content", "post_time", "user_id", "passport_token"]
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

        if !params[:image].nil? || !params[:image].blank?

          eventImage = EventImage.new
          eventImage.event_id = event.id
          eventImage.update_attributes(:image => params[:image])
          eventImage.width = params[:image_width]
          eventImage.height = params[:image_height]

          if eventImage.save

            msg[:img_description] = "图像上传成功"
          else
            msg[:img_description] = "图像上传失败"
          end
        end

        msg[:response] =CodeHelper.CODE_SUCCESS
        msg[:description] = "用户添加event成功"
        msg[:event_id] = event.id
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



  def searchSpecificTimeCapsule

    msg = Hash.new

    if  params[:longitude].nil?  ||  params[:latitude].nil?   ||  params[:user_id].nil? ||  params[:event_id].nil?  ||  params[:passport_token].nil?

      arr_params = [ "longitude", "latitude", "user_id", "passport_token", "event_id"]
      msg[:response] = CodeHelper.CODE_MISSING_PARAMS(arr_params)
      msg[:description] = "请提供所需参数"
      render :json =>  msg.to_json
      return
    end


    checkUser = checkUserExistBeforeOperationStart(params[:user_id], msg)

    if checkUser

      specificCapsule = Event.find_by_id(params[:event_id])

      if !specificCapsule.nil?

        msg[:response] =CodeHelper.CODE_SUCCESS
        msg[:description] = "返回事件成功"
        msg[:event] = specificCapsule
        render :json =>  msg
        return
      else

        msg[:response] =CodeHelper.CODE_FAIL
        msg[:description] = "事件不存在"
        msg[:event] = ""
        render :json =>  msg
        return
      end
    end

  end

  api :GET, "/event/searchTimeCapsule", "搜索附近的时光胶囊"

  param :user_id, String, "用户 id， 可以多个用,隔开  e.g. 1,2,3,4,5", :required => true
  param :passport_token, String, "用户令牌，用于操作的身份验证", :required => true
  param :longitude, String, "位置longitude", :required => true
  param :latitude, String, "位置latitude", :required => true

  description <<-EOS


  EOS
  def searchTimeCapsule

    msg = Hash.new

    if  params[:longitude].nil?  ||  params[:latitude].nil?   ||  params[:user_id].nil?  ||  params[:passport_token].nil?

      arr_params = [ "longitude", "latitude", "user_id", "passport_token"]
      msg[:response] = CodeHelper.CODE_MISSING_PARAMS(arr_params)
      msg[:description] = "请提供所需参数"
      render :json =>  msg.to_json
      return
    end

    checkUser = checkUserExistBeforeOperationStart(params[:user_id], msg)

    if checkUser

      if  params[:latitude].to_f == 0.0 || params[:longitude].to_f == 0.0

        msg[:response] =CodeHelper.CODE_REFRESH
        msg[:description] = "返回事件失败,GPS坐标无效"
        msg[:events] = ""
        render :json =>  msg
        return
      end

      allTimeCapsules = Event.order("updated_at desc").all

      if params[:distance].nil?

        distance_value = CodeHelper.USER_DISTANCE
      else

        distance_value = params[:distance]
      end

      arr_timeCapsules = Array.new

      if allTimeCapsules.count > 0

        for cap in allTimeCapsules

          a_distance = [params[:latitude].to_f, params[:longitude].to_f]
          location = cap.e_location
          post_user =  User.find_by_id (cap.user_id)

          logger.info "getting  zero  gps  #{params[:latitude].to_f}, #{params[:longitude].to_f}"

          if !location.nil?

            b_distance =  [location.latitude.to_f, location.longitude.to_f]

            presenting_capsule =  distance(a_distance, b_distance)
            logger.info "do we get distance value #{presenting_capsule}"

            if presenting_capsule <= distance_value

              arr_timeCapsules << cap
            end
          end
        end

        msg[:response] =CodeHelper.CODE_SUCCESS
        msg[:description] = "返回事件成功"
        msg[:user_distance] = CodeHelper.USER_DISTANCE
        msg[:distance_update_meter] = CodeHelper.DISTANCE_METER_UPDATE
        msg[:events] = arr_timeCapsules
        render :json =>  msg
        return
      else

        msg[:response] =CodeHelper.CODE_FAIL
        msg[:description] = "周围没有事件"
        msg[:events] = ""
        render :json =>  msg
        return
      end
    end
  end

  api :GET, "/event/saveTimeCapsule", "保存附近的时光胶囊"

  param :user_id, String, "用户 id， 可以多个用,隔开  e.g. 1,2,3,4,5", :required => true
  param :event_id, String, "已经创建好的event", :required => true
  param :passport_token, String, "用户令牌，用于操作的身份验证", :required => true
  param :longitude, String, "位置longitude", :required => true
  param :latitude, String, "位置latitude", :required => true
  param :address, String, "位置地址详情", :required => true
  param :save_time, String, "埋藏时间", :required => true

  description <<-EOS


  EOS
  def saveTimeCapsule

    msg = Hash.new

    if params[:user_id].nil?  || params[:event_id].nil?||  params[:address].nil?  ||  params[:latitude].nil? ||
                params[:longitude].nil? ||  params[:passport_token].nil?  ||  params[:save_time].nil?

      arr_params = ["event_id", "address", "latitude","longitude", "user_id", "passport_token", "save_time", "expire_time"]
      msg[:response] = CodeHelper.CODE_MISSING_PARAMS(arr_params)
      msg[:description] = "请提供所需参数"
      render :json =>  msg.to_json
      return
    end

    isUserExist = checkUserExistBeforeOperationStart(params[:user_id], msg)

    if isUserExist

        event = Event.find_by_id(params[:event_id])

        if event.nil?

          msg[:response] = CodeHelper.CODE_FAIL
          msg[:description] = "该时光胶囊不存在"
          render :json =>  msg.to_json
          return
        else

          if !event.e_location.nil?

            msg[:response] = CodeHelper.CODE_FAIL
            msg[:description] = "该时光胶囊已经埋藏过一个位置"
            render :json =>  msg.to_json
            return
          else

            capsule_location = event.create_e_location
            capsule_location.event_id =  params[:event_id]
            capsule_location.title =  params[:title]
            capsule_location.content =  params[:content]
            capsule_location.address =  params[:address]
            capsule_location.latitude =  params[:latitude]
            capsule_location.longitude =  params[:longitude]
            capsule_location.begin_date =  Time.parse(params[:save_time])

            if capsule_location.save

              msg[:response] =CodeHelper.CODE_SUCCESS
              msg[:description] = "保存时光胶囊成功"
              render :json =>  msg
              return
            else

              msg[:response] =CodeHelper.CODE_FAIL
              msg[:description] = "保存时光胶囊失败"
              render :json =>  msg
              return
            end
          end
         end
    end
  end


  api :POST, "/event/getUsersEvents", "用户events list (时光胶囊)"

  param :user_id, String, "用户 id", :required => true
  param :passport_token, String, "用户令牌，用于操作的身份验证", :required => true

  description <<-EOS


  EOS
  def getUsersEvents

    msg = Hash.new

    if  params[:user_id].nil? ||  params[:passport_token].nil?

      arr_params = [ "user_id", "passport_token"]
      msg[:response] = CodeHelper.CODE_MISSING_PARAMS(arr_params)
      msg[:description] = "请提供所需参数"
      render :json =>  msg.to_json
      return
    end

    checkUser = User.find_by_id(params[:user_id])

    if checkUser

      event_timeCapsule = Event.where("user_id = ?", params[:user_id]).order("created_at desc")

      if event_timeCapsule.count > 0

        msg[:response] =CodeHelper.CODE_SUCCESS
        msg[:description] = "返回事件成功"
        msg[:event] = event_timeCapsule
        render :json =>  msg
        return
      else

        msg[:response] =CodeHelper.CODE_EVENT_FAIL
        msg[:description] = "返回事件失败"
        render :json =>  msg
        return
      end
    else

      msg[:response] =CodeHelper.CODE_FAIL
      msg[:description] = "用户不存在"
      render :json =>  msg
      return
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

        if  !event_tobe_deleted.event_images.nil?  && event_tobe_deleted.event_images.count > 0

          for img in   event_tobe_deleted.event_images

            img = nil
          end

          event_tobe_deleted.event_images.destroy_all()
        end

        if  !event_tobe_deleted.comments.nil?

          event_tobe_deleted.comments.destroy_all()
        end

        if  !event_tobe_deleted.e_location.nil?

          event_tobe_deleted.e_location.delete
        end

        if  !event_tobe_deleted.report_events.nil?

          event_tobe_deleted.report_events.destroy_all()
        end

        if  event_tobe_deleted.delete

          msg[:response] = CodeHelper.CODE_SUCCESS
          msg[:description] = "删除event成功"
          render :json =>  msg.to_json
          return

        else

          msg[:response] = CodeHelper.CODE_FAIL
          msg[:description] = "删除event失败"
          render :json =>  msg.to_json
          return
        end



      end
    end
  end


  api :POST, "/event/report_event", "用户举报事件"

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

        report_event = ReportEvent.where("event_id = ? && user_id = ?", params[:event_id], params[:user_id]).first

        if !report_event.nil?

          msg[:response] = CodeHelper.CODE_REPORT_REPEAT
          msg[:description] = "你已经举报过了"
          render :json =>  msg.to_json
          return
        end

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


  api :POST, "/event/uploadEventImage", "用户添加event image"

  param :event_id, String, "用户event id", :required => true
  param :user_id, String, "用户 id", :required => true
  param :image, String, "用户上传的图像data", :required => true
  param :image_height, String, "用户上传的图像height", :required => true
  param :image_width, String, "用户上传的图像height", :required => true
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
        eventImage.width = params[:image_width]
        eventImage.height = params[:image_height]

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
