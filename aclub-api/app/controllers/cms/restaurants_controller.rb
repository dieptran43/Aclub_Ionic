module Cms
  class RestaurantsController < BaseController
    def index
      if params[:city]
        @restaurants = Restaurant.where(city_id: params[:city]).order('name').get_index(page: params[:page])
        @city_id = params[:city]
      else
        @restaurants = Restaurant.order('name').page(params[:page])
      end
      @restaurants = @restaurants.index_by_name(params[:query])

      respond_to do |format|
        format.html
        format.json { render json: Restaurant.index_by_name(params[:query]).pluck(:name, :id) }
      end
    end

    def show
      @restaurant = Restaurant.find_by_id(params[:id])
    end

    def edit
      @restaurant = Restaurant.find(params[:id])
    end

    def update
      restaurant = Restaurant.find_by_id(params[:id])
      if restaurant.update_attributes(restaurant_params)
        redirect_to action: :show, id: restaurant.id
      end
    end

    def destroy
      restaurant = Restaurant.find(params[:id]).destroy
    end

    private
    def restaurant_params
      params.require(:restaurant).permit!
    end
  end
end
