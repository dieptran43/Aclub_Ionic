class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  def after_sign_out_path_for(resource)
    new_admin_session_path
  end

  def after_sign_in_path_for(resource)
    if resource.admin?
      cms_restaurants_path
    elsif Restaurant.find_by(owner: resource)
      code_form_owner_coupons_path
    else
      if resource.facebook_fanpages.empty?
        owner_third_party_accounts_path
      else
        owner_facebook_fanpages_path
      end
    end
  end

  private
  def set_side_bar
    @with_side_bar = true
  end

  def set_header
    @with_header = true
  end

  def set_header_background_color
    @with_header_background_color = true
  end
end
