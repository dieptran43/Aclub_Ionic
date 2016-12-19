module Owner
  class BaseController < ApplicationController
    before_action :authenticate_restaurant_owner!, :set_header, :set_side_bar

    def current_ability
      @current_ability ||= AdminAbility.new(current_admin)
    end

    def authenticate_restaurant_owner!
      unless current_admin.try(:owner?)
        redirect_to root_path, alert: "Access Denied!"
      end
    end
  end
end