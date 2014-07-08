#encoding: UTF-8
class CategoryController < ApplicationController
  protect_from_forgery


  api :GET, "/category/listCategory", "列出用户可创建event category"
  param :user_id, String, "用户 id", :required => true
  param :passport_token, String, "用户令牌，用于操作的身份验证", :required => true

  description <<-EOS


  EOS

  def listCategory

    msg = Hash.new

    if params[:user_id].nil? ||  params[:passport_token].nil?

      arr_params = [ "user_id", "passport_token"]
      msg[:response] = CodeHelper.CODE_MISSING_PARAMS(arr_params)
      msg[:description] = "请提供所需参数"
      render :json =>  msg.to_json
      return
    end

    user = User.find_by_id(params[:user_id])

    if user.nil?

      msg[:response] =CodeHelper.CODE_USER_NOT_EXIST
      msg[:description] = "无法进行此操作, 用户不存在"
      render :json =>  msg
      return
    else

      if user.passport_token != params[:passport_token]

        msg[:response] =CodeHelper.CODE_FAIL
        msg[:description] = "用户token失效，请重新登录"
        render :json =>  msg
        return
      end

      category = Category.all

      if category.count > 0

        msg[:response] =CodeHelper.CODE_SUCCESS
        msg[:category] = category
        msg[:description] = "返回所有categories成功"
        render :json =>  msg
        return
      else

        msg[:response] =CodeHelper.CODE_FAIL
        msg[:category] = ""
        msg[:description] = "返回categories失败"
        render :json =>  msg
        return
      end
    end
  end

  api :POST, "/category/addCategory", "用户可创建event category"
  param :user_id, String, "用户 id", :required => true
  param :category_name, String, "用户 category name", :required => true
  param :introduction, String, "用户 category 介绍", :required => true
  param :passport_token, String, "用户令牌，用于操作的身份验证", :required => true

  description <<-EOS


  EOS
  def addCategory

    msg = Hash.new

    if params[:user_id].nil? ||  params[:passport_token].nil?   ||  params[:category_name].nil? ||  params[:introduction].nil?

      arr_params = [ "user_id", "passport_token", "category_name"]
      msg[:response] = CodeHelper.CODE_MISSING_PARAMS(arr_params)
      msg[:description] = "请提供所需参数"
      render :json =>  msg.to_json
      return
    end

    user = User.find_by_id(params[:user_id])

    if user.nil?

      msg[:response] =CodeHelper.CODE_USER_NOT_EXIST
      msg[:description] = "无法进行此操作, 用户不存在"
      render :json =>  msg
      return
    else

      if user.passport_token != params[:passport_token]

        msg[:response] =CodeHelper.CODE_FAIL
        msg[:description] = "用户token失效，请重新登录"
        render :json =>  msg
        return
      end

      newCategory = Category.new
      newCategory.name = params[:category_name]
      newCategory.introduction = params[:introduction]

      if newCategory.save

        msg[:response] =CodeHelper.CODE_SUCCESS
        msg[:description] = "用户添加category成功"
        render :json =>  msg
        return
      else

        msg[:response] =CodeHelper.CODE_FAIL
        msg[:description] = "用户添加category失败"
        render :json =>  msg
        return
      end
    end
  end


  #api :POST, "/category/deleteCategory", "用户删除 event category"
  #param :user_id, String, "用户 id", :required => true
  #param :category_name, String, "用户 category name", :required => true
  #param :introduction, String, "用户 category 介绍", :required => true
  #param :passport_token, String, "用户令牌，用于操作的身份验证", :required => true
  #
  #description <<-EOS
  #
  #
  #EOS
  def deleteCategory

    msg = Hash.new

    if params[:user_id].nil? ||  params[:passport_token].nil?   ||  params[:category_id].nil?
      arr_params = [ "user_id", "passport_token", "category_id"]
      msg[:response] = CodeHelper.CODE_MISSING_PARAMS(arr_params)
      msg[:description] = "请提供所需参数"
      render :json =>  msg.to_json
      return
    end

    user = User.find_by_id(params[:user_id])

    if user.nil?

      msg[:response] =CodeHelper.CODE_USER_NOT_EXIST
      msg[:description] = "无法进行此操作, 用户不存在"
      render :json =>  msg
      return
    else

      if user.passport_token != params[:passport_token]

        msg[:response] =CodeHelper.CODE_FAIL
        msg[:description] = "用户token失效，请重新登录"
        render :json =>  msg
        return
      end

    end
  end


  def updateCategory


  end

end
