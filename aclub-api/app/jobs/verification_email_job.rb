class VerificationEmailJob < ActiveJob::Base
  queue_as :high_priority

  def perform(user_id)
    if user = User.find_by_id(user_id)
      if user.unverified_email
        UserMailer.send_email_verification_code(user.email_verification_token, user.unverified_email).deliver_now
        p "--Finished sending email verification to #{user.unverified_email}!--"
      end
    else
      p "--record not found!--"
    end
  end
end
