module Cms
  class UsersController < BaseController
    def index
      @users = User.search(params[:query]).order('updated_at DESC').page(params[:page])
    end

    def show
      @user = User.find_by_id(params[:id])
      client = Koala::Facebook::API.new(@user.facebook_token)
      begin
        data = client.get_object('me', fields: [:age_range])
        @user.update_attributes(age_range: data["age_range"])
      rescue
      end
    end

    def destroy
      user = User.find_by_id(params[:id])
      user.destroy
      redirect_to action: :index
    end
  end
end
