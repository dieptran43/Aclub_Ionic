module Cms
  class RestaurantOwnersController < BaseController
    def index
      @owners = Admin.owners.search(params[:query]).order('updated_at DESC').page(params[:page])
    end

    def show
      @owner = Admin.find_by_id(params[:id])
    end

    def new
      @owner = Admin.new
    end

    def update
      owner = Admin.find_by_id(params[:id])
      if owner.update_owner(owner_params)
        if params[:restaurant_id]
          Restaurant.where(owner: owner).update_all(owner_id: nil, owner_type: nil)
          Restaurant.find_by_id(params[:restaurant_id]).update_attributes(owner: owner)
        end
        redirect_to action: :show, id: owner.id
      else
        redirect_to action: :index
      end
    end

    def edit
      @owner = Admin.find_by_id(params[:id])
    end

    def create
      owner = Admin.new(owner_params)
      if owner.save
        if params[:restaurant_id]
          Restaurant.find_by_id(params[:restaurant_id]).update_attributes(owner: owner)
        end
        RestaurantOwnerInvitationJob.perform_later(owner_params[:email], owner_params[:password])
        redirect_to action: :show, id: owner.id
      else
        redirect_to action: :index
      end
    end

    def destroy
      owner = Admin.find_by_id(params[:id])
      owner.destroy
      redirect_to action: :index
    end

    private
    def owner_params
      params.require(:admin).permit(:id, :phone, :email, :password, :name, venue_ids: [])
    end
  end
end
