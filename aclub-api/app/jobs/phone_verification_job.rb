class PhoneVerificationJob < ActiveJob::Base
  queue_as :high_priority

  def perform(user)
    if user
      Api::SMS.send_message(user)
      p "--Finished Send verification code to #{user.phone}!--"
    else
      p "--record not found!--"
    end
  end
end
