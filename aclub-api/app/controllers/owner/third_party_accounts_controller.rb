module Owner
  class ThirdPartyAccountsController < BaseController
    before_filter :redirect_to_fanpage_list, only: [:index, :page_list]
    before_filter :set_header_background_color
    skip_before_filter :set_header, :set_side_bar

    def index
      @no_side_bar = true
    end

    def page_list
      @identity = FacebookIdentity.find(params[:identity_id])
      @accounts = @identity.fetch_accounts
    end

    def sync_data_from_facebook_account
      data = JSON.parse(params[:fanpage])
      uid = data["id"]
      name = data["name"]
      access_token = data["access_token"]
      fanpage = FacebookFanpage.new(admin: current_admin, name: name)
      identity = FacebookIdentity.find_or_initialize_by(uid: uid)
      identity.user = fanpage
      identity.access_token = access_token
      if fanpage.save && identity.save
        identity.crawl_facebook_data
        redirect_to owner_facebook_fanpages_path
      else
        redirect_to action: :page_list, identity_id: params[:identity_id]
      end
    end

    private
    def redirect_to_fanpage_list
      unless current_admin.facebook_fanpages.empty?
        redirect_to owner_facebook_fanpages_path
      end
    end
  end
end