module Api
  class SessionsController < BaseController
    def create
      session_service = SessionService.new(signin_params)
      if session_service.create
        render json: session_service.response_data
      else
        render_errors(session_service.errors, :unauthorized)
      end
    end

    def request_phone_verification_token
      normalized_phone = Api::PhoneParser.normalize(signin_params[:phone])
      if user = User.find_by_phone(normalized_phone)
        user.generate_phone_verification_token
        user.save
        user.send_verification_code
        head :ok
      else
        render_errors(I18n.t("controller.sessions.not_found"), :not_found)
      end
    end

    private

    def signin_params
      params[:user].permit(:phone, :verification_token, :device_token, :email, :password, :username, :user_agent)
    end
  end
end
