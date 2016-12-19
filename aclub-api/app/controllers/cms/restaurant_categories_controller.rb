module Cms
  class RestaurantCategoriesController < BaseController
    def index
      @restaurant_categories = RestaurantCategory.all
    end

    def new
      @page_title = t('cms.restaurant_categories.title')
      @restaurant_category = RestaurantCategory.new
    end

    def create
      if restaurant_category = RestaurantCategory.create(restaurant_category_params)
        redirect_to cms_restaurant_category_path(restaurant_category)
      end
    end

    def show
      @restaurant_category = RestaurantCategory.find_by_id(params[:id])
    end

    def destroy
      if restaurant_category = RestaurantCategory.find_by_id(params[:id])
        restaurant_category.destroy
        redirect_to cms_restaurant_categories_path
      end
    end

    def edit
      @restaurant_category = RestaurantCategory.find_by_id(params[:id])
    end

    def update
      if restaurant_category = RestaurantCategory.find_by_id(params[:id])
        restaurant_category.update_attributes(restaurant_category_params)
        redirect_to cms_restaurant_category_path(restaurant_category)
      end
    end

    private
    def restaurant_category_params
      params.require(:restaurant_category).permit(
        :name, :alias, :image
      )
    end
  end
end
