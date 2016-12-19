module Api
  class RegistrationService
    attr_accessor :signup_params, :user, :errors, :device_token, :user_agent

    def initialize(signup_params)
      self.signup_params = signup_params
      self.device_token = signup_params.delete(:device_token)
      self.user_agent = signup_params.delete(:user_agent)
    end

    def create
      self.user = User.new(signup_params)
      if result = user.save
        user.add_device_token(device_token, user_agent)
      end
      result
    end

    def response_data
      AuthorizedUserPresenter.new(user)
    end
    
    def response_data_fb
      user
    end

    def errors
      ModelErrorsPresenter.new(user)
    end
  end
end
