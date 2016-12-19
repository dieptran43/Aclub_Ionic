module Api
  class InteractivityStatusesController < BaseController
    before_action :authenticate_user!

    def index
      if has_params?([:phones], :interactivity_statuses)
        user_interactivity_service = UserInteractivityStatusService.new(current_user, interactivity_statuses_params[:phones])
        user_interactivity_service.process
        render json: user_interactivity_service.response_data
      end
    end

    private

    def interactivity_statuses_params
      params[:interactivity_statuses].permit(phones: [])
    end
  end
end
