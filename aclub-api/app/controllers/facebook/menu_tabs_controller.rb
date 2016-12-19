module Facebook
  class MenuTabsController < ApplicationController
    include Api
    skip_before_filter :verify_authenticity_token
    before_filter :allow_iframe_requests

    def index
      if params[:signed_request]
        session[:signed_request] = FacebookVoucherService.decode_facebook_hash(params[:signed_request])
        @available_menu = Menu.get_by_owner_fanpage_id(session[:signed_request]['page']['id'])
        render :layout => 'menu_tab'
      else
        render :nothing => true, :status => 400
      end
    end

    private
    def signup_params
      params[:user].permit(:phone)
    end
    def allow_iframe_requests
      response.headers.delete('X-Frame-Options')
    end
  end
end
