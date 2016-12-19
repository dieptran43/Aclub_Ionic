module Api
  class UserService
    attr_accessor :user_params, :user

    def initialize(user, user_params)
      self.user = user
      self.user_params = user_params
    end

    def update
      user.update_attributes(user_params)
    end

    def response_data
      AuthorizedUserPresenter.new(user)
    end

    def errors
      ModelErrorsPresenter.new(user)
    end

    def verify_email
      comparation = Devise.secure_compare(user_params[:email_token], user.email_verification_token)
      if comparation
        email = user.unverified_email
        update_result = user.update_attributes(unverified_email: nil, email_verification_token: nil, email: email)
      end
      comparation && update_result
    end

    def register_email_password
      user.generate_email_verification_token
      user.unverified_email = user_params[:email]
      user.password = user_params[:password]
      user.save
    end
  end
end
