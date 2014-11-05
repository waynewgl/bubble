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

    msg = Hash.new
    msg[:response] =CodeHelper.CODE_ADMIN_OPEN
    render :json =>  msg
  end

end
