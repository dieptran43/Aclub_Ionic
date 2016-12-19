module Owner
  class RestaurantsController < BaseController
    def index
      @restaurants = current_admin.restaurants.page(params[:page])
      @searching_restaurants = Restaurant.search_by_name(params[:query]).page(params[:page])
    end

    def restaurant_reviews
      RestaurantWaitListReview.create(facebook_fanpage: current_admin.default_fanpage, restaurant_id: params[:restaurant_id])
    end

    def new
      Facebook::FacebookDataCrawlService.new(current_admin.default_fanpage).update_data(Restaurant.new)
      redirect_to action: :index
    end

    def create
      restaurant = Restaurant.new(restaurant_params)
      restaurant.owner = current_admin.default_fanpage
      if restaurant.save
        redirect_to action: :index
      end
    end

    def edit
      @restaurant = Restaurant.find(params[:id])
    end

    def show
      @restaurant = Restaurant.find(params[:id])
    end

    def update
      restaurant = Restaurant.find(params[:id])
      if restaurant.update_attributes(restaurant_params)
        redirect_to action: :index
      end
    end

    def destroy
      Restaurant.find(params[:id]).destroy
      redirect_to action: :index
    end

    private
    def restaurant_params
      params.require(:restaurant).permit!
    end
  end
end