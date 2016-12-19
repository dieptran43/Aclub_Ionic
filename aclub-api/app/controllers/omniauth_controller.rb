class OmniauthController < ApplicationController
  def omniauth_callback
    admin = Admin.find(request.env['omniauth.params']['admin_id']) if request.env['omniauth.params']
    token = request.env['omniauth.auth'].credentials.token
    uid = request.env['omniauth.auth'].extra.raw_info.id
    identity = FacebookIdentity.find_or_initialize_by(uid: uid)
    identity.user = admin
    identity.access_token = token
    if identity.save
      redirect_to page_list_owner_third_party_accounts_path(identity_id: identity.id)
    else
      redirect_to owner_third_party_accounts_path
    end
  end

  def omniauth_fallback
    redirect_to owner_third_party_accounts_path
  end
end