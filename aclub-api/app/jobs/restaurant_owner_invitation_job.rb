class RestaurantOwnerInvitationJob < ActiveJob::Base
  queue_as :default

  def perform(email, password)
    UserMailer.send_password_to_owner(email, password).deliver_now
  end
end
