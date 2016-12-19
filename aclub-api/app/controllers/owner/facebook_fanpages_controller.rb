module Owner
  class FacebookFanpagesController < BaseController
    def index
      @facebook_fanpages = current_admin.facebook_fanpages
    end

    def destroy
      facebook_fanpage = FacebookFanpage.find(params[:id]).destroy
      redirect_to action: :index
    end
  end
end