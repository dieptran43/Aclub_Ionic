module ApiHeaderHelper
  extend RSpec::SharedContext

  let!(:user) { create(:user) }
  let(:ios_client) { create(:client_application) }

  def set_api_headers
    request.headers["HTTP_APPLICATION_TOKEN"] = ios_client.token
  end

  def set_api_authorized_headers(current_user=user)
    set_api_headers
    request.headers["HTTP_PHONE"] = current_user.phone
    request.headers["HTTP_TOKEN"] = current_user.authentication_token.token
  end
end
