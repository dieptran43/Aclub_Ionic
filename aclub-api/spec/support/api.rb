RSpec.configure do |config|

  config.before(:each, set_api_headers: true) do
    set_api_headers
  end

  config.before(:each, set_api_authorized_headers: true) do
    set_api_authorized_headers
  end

end