class OmniauthService
  attr_accessor :omniauth_info

  def initialize(omniauth_info)
    self.omniauth_info = omniauth_info
  end

  def authenticate_user
    if user = User.find_by(email: self.omniauth_info.info.email)
      user.facebook_token = self.omniauth_info.credentials.token
      user.facebook_token_expiration = self.omniauth_info.credentials.expires_at
      user.facebook_image_url = self.omniauth_info.info.image
    else
      user = User.new(
        email: self.omniauth_info.info.email,
        name: self.omniauth_info.info.name,
        facebook_image_url: self.omniauth_info.info.image,
        facebook_token: self.omniauth_info.credentials.token,
        facebook_token_expiration: self.omniauth_info.credentials.expires_at
      )
    end

    if user.save(validate: false)
      user
    end
  end
end
