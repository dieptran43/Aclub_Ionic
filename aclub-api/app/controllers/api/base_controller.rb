module Api
  class BaseController < ApplicationController
    respond_to :json

    skip_before_action :verify_authenticity_token
    before_action :require_application_token!

    private

    def require_application_token!
      unless ClientApplication.exists?(token: request.headers['HTTP_APPLICATION_TOKEN'])
        render_errors('Invalid application token', :bad_request)
      end
    end

    def authenticate_user!
      if current_user.blank?
        render_errors("Invalid token", :unauthorized)
      end
    end

    def current_user
      return @current_user if @current_user
      token_authentication_service = TokenAuthenticationService.new(
        request.headers['HTTP_PHONE'],
        request.headers['HTTP_TOKEN']
      )

      if token_authentication_service.verify
        @current_user = token_authentication_service.user
      end
    end

    def render_errors(message, status)
      render json: { errors: message }, status: status
    end

    def has_params?(required_params, root=nil)
      root_params = root ? params[root] : params
      missing_params = if root_params
                         required_params.select { |param| root_params[param].blank? }
                       else
                         required_params
                       end
      if missing_params.present?
        errors_message = "Missing parameters: #{root}[#{missing_params.join(", ")}]"
        render_errors(errors_message, :unprocessable_entity)
        false
      else
        true
      end
    end

    def require_location
      unless params[:latitude] && params[:longitude]
        render_errors("latitude and longitude are required", 422)
      end
    end
  end
end
