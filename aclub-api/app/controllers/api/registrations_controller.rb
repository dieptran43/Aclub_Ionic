module Api
  class RegistrationsController < BaseController
    def create
      registration_service = RegistrationService.new(signup_params)
      if registration_service.create
        render json: registration_service.response_data
      else
        render json: registration_service.errors, status: :unprocessable_entity
      end
    end

    private
    def signup_params
      params[:user].permit(:phone, :email, :password, :device_token, :user_agent)
    end
  end
end
