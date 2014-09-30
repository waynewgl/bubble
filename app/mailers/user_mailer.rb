#encoding: UTF-8

class UserMailer < ActionMailer::Base
  default from: "appscreator@163.com"
  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.user_mailer.confirm.subject
  #
  def confirm(user,subject)

    @user = user
    mail(:subject => "#{subject}", :to => user[:account])

  end
end
