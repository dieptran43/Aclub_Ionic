module Cms
  class MenusController < BaseController
    def edit
      @menu = Menu.find(params[:id])
    end

    def update
      menu = Menu.find(params[:id])
      if menu.update_attributes(menu_params)
        redirect_to edit_cms_restaurant_path(menu.owner)
      end 
    end

    def new
      @restaurant = Restaurant.find_by_id(params[:restaurant_id])
      @menu = Menu.new
    end

    def create
      menu = Menu.new(menu_params)
      if menu.save
        redirect_to edit_cms_restaurant_path(menu.owner)
      end
    end

    private
    def menu_params
      params.require(:menu).permit!
    end
  end
end