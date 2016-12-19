module Api
  class EnvsController < BaseController
    before_filter :require_location

    def index
      render json: EnvPresenter.new(params[:latitude], params[:longitude])
    end
  end
end