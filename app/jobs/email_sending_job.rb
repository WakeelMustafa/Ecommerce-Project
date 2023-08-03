class EmailSendingJob < ApplicationJob
  queue_as :default

  def perform(*args)
    users = User.all
    users.each do |user|
      UserMailer.send_email(user).deliver_now
    end
  end
end
