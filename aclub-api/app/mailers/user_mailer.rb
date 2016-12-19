class UserMailer < ActionMailer::Base
  default from: 'postmaster@mg.expife.com'
  EMAIL_VERIFICATION_SUBJECT = "Mã xác nhận email của bạn"
  PASSWORD_SUBJECT = "Password cua ban"

  def send_email_verification_code(token, email)
    @token = token
    mail(to: email, subject: EMAIL_VERIFICATION_SUBJECT)
  end

  def send_password_to_owner(email, password)
    @password = password
    mail(to: email, subject: PASSWORD_SUBJECT)
  end
end
