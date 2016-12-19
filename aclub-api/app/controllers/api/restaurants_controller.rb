module Api
  class RestaurantsController < BaseController
    before_action :require_restaurant!, only: [:show]

    def index
      restaurants = Restaurant.get_index(restaurant_params)
      render json: ArrayPresenter.new(restaurants, RestaurantPresenter)
    end

    def show
      impressionist(@restaurant, Restaurant::VIEW)
      render json: RestaurantPresenter.new(@restaurant)
    end

    private
    def restaurant_params
      params.permit(:page, :restaurant_category_id, :query)
    end

    def require_restaurant!
      if has_params?([:id])
        @restaurant = Restaurant.find_by(id: params[:id])
        render_errors(I18n.t('base.api.not_found'), :not_found) unless @restaurant
      end
    end
  end
end
