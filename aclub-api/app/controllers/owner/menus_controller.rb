module Owner
  class MenusController < BaseController
    def index
      @menus = current_admin.menus
    end

    def show
      @menu = Menu.find(params[:id])
    end

    def edit
      @menu = Menu.find(params[:id])
    end

    def new
      @menu = Menu.new
    end

    def destroy
      Menu.find(params[:id]).destroy
      redirect_to action: :index
    end

    def update
      menu = Menu.find(params[:id])
      if menu.update_attributes(menu_params)
        redirect_to action: :show, id: menu.id
      end
    end

    def create
      menu = Menu.new(menu_params)
      menu.owner = current_admin
      if menu.save
        redirect_to action: :show, id: menu.id
      end
    end

    private
    def menu_params
      params.require(:menu).permit(:name, :category, :price, :image, menu_components_attributes: [:id, :content, :_destroy])
    end
  end
end