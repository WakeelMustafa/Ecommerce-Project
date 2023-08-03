class UserMailer < ApplicationMailer
  def send_email(user)
    @user = user
    mail(to: @user.email, subject: 'Wakeel Ecommerce Store')
  end
end
