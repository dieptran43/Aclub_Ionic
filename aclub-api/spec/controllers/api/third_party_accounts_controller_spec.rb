require 'rails_helper'

module Api
  RSpec.describe ThirdPartyAccountsController, type: :controller, api: true do
    describe 'POST create', set_api_headers: true do
      let(:device_token) { Faker::Lorem.characters(64) }
      let(:third_party_params) { { uid: Faker::Internet.email, provider: Faker::Internet.mac_address, access_token: device_token, device_token: device_token } }
      let(:third_party_account_service) { double }

      before do
        expect(ThirdPartyAccountService).to receive(:new).with(third_party_params).and_return(third_party_account_service)
        expect(third_party_account_service).to receive(:create).and_return(create_status)
      end

      context 'sign in successfully' do
        let(:response_data) { { token: Faker::Lorem.characters(8) } }
        let(:create_status) { true }

        before do
          expect(third_party_account_service).to receive(:response_data).and_return(response_data)

          post :create, user: third_party_params
        end

        it 'returns user response with ok status' do
          expect(response.status).to eq 200
          expect(json_response).to eq response_data.stringify_keys
        end
      end
    end
  end
end
