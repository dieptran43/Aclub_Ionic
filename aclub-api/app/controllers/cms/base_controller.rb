module Cms
  class BaseController < ApplicationController
    before_action :authenticate_super_admin!, :set_header, :set_side_bar

    def authenticate_super_admin!
      unless current_admin.try(:admin?)
        redirect_to root_path, alert: "Acess Denied!"
      end
    end
  end
end