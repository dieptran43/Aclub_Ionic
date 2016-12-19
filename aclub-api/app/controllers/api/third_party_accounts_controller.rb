module Api
  class ThirdPartyAccountsController < BaseController
    def create
      if has_params?([:uid, :provider, :access_token], :user)
        third_party_account_service = ThirdPartyAccountService.new(third_party_params)
        if third_party_account_service.create
          render json: third_party_account_service.response_data
        else
          render_errors(third_party_account_service.errors, :unprocessable_entity)
        end
      end
    end

    private

    def third_party_params
      params[:user].permit(:uid, :provider, :access_token, :access_token_secret, :device_token, :phone, :user_agent)
    end
  end
end
