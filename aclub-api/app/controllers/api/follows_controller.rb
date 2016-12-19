module Api
  class FollowsController < BaseController
    before_action :set_followable
    before_action :authenticate_user!

    def create
      if @followable.present?
        current_user.follow(@followable)
        head :ok
      else
        render_errors(I18n.t("base.api.not_found"), :not_found)
      end
    end

    def destroy
      if @followable.present?
        current_user.stop_following(@followable)
        head :ok
      else
        render_errors(I18n.t("base.api.not_found"), :not_found)
      end
    end
    
    private

    def set_followable
      @followable = follow_params[:followable_type].constantize.find_by_id(follow_params[:followable_id])
    end

    def follow_params
      params[:follow].permit(:followable_id, :followable_type)
    end
  end
end
