module Api
  class RestaurantCategoriesController < BaseController
    def restaurants
      restaurant_category = RestaurantCategory.find(params[:id])
      render json: ArrayPresenter.new(restaurant_category.restaurants.page(params[:page]), RestaurantPresenter)
    end
  end
end
