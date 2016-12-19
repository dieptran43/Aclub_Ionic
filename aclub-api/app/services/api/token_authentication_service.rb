module Api
  class TokenAuthenticationService
    attr_accessor :phone, :token, :user

    def initialize(phone, token)
      self.phone = phone.presence
      self.token = token
    end

    def verify
      self.user = phone && User.find_by(phone: phone)
      authentication_token = user && user.authentication_token
      Devise.secure_compare(authentication_token.try(:token), token)
    end
  end
end
