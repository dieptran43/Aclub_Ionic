module Api
  class SessionService
    attr_accessor :signin_params, :user, :errors, :device_token, :user_agent

    def initialize(signin_params)
      self.signin_params = signin_params
      self.device_token = signin_params.delete(:device_token)
      self.user_agent = signin_params.delete(:user_agent)
    end

    def create
      if signin_params[:verification_token]
        sign_in_by_token
      else
        sign_in_by_password
      end

      errors.blank?
    end

    def sign_in_by_token
      normalized_phone = Api::PhoneParser.normalize(signin_params[:phone])
      self.user = User.find_for_database_authentication(phone: normalized_phone)

      if user
        if user.verification_token != signin_params[:verification_token]
          self.errors = I18n.t("controller.users.invalid_verification_code")
        else
          user.add_device_token(device_token, user_agent)
        end
      else
        self.errors = I18n.t("controller.sessions.not_found")
      end
    end

    def sign_in_by_password
      if signin_params[:username]
        unless self.user = User.find_for_database_authentication(email: signin_params[:username])
          normalized_phone = Api::PhoneParser.normalize(signin_params[:username])
          self.user = User.find_for_database_authentication(phone: normalized_phone)
        end
      end

      if user
        if !user.valid_password?(signin_params[:password])
          self.errors = I18n.t("controller.users.invalid_password")
        else
          user.add_device_token(device_token, user_agent)
        end
      else
        self.errors = I18n.t("controller.sessions.not_found")
      end
    end

    def response_data
      AuthorizedUserPresenter.new(user)
    end
  end
end
