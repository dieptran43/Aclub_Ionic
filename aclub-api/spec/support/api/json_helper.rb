module JsonHelper
  extend RSpec::SharedContext
  let(:json_response) { JSON.parse(response.body) }
end
