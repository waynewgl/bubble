class UserMailer < ActionMailer::Base
  default from: "app__developer@163.com"

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.user_mailer.confirm.subject
  #
  def confirm(user,subject)

    @user = user
    mail(:to => user[:account], :subject => "#{subject}")

  end
end
