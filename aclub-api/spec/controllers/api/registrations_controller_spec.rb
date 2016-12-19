require 'rails_helper'

module Api
  describe RegistrationsController, api: true do
    describe '#create', set_api_headers: true do
      let(:password) { 'password' }
      let!(:user) { create(:user, password: password) }
      let(:valid_signup_params) { { phone: '84989471288' } }
      let(:exist_user_signup_params) { { phone: user.phone} }

      context 'pass valid data' do
        let(:expected_json) { {
          "id" => User.last.id,
          "name" => User.last.name,
          "phone" => User.last.phone,
        } }

        before do
          expect {
            post :create, user: valid_signup_params
          }.to change { User.count }.by(1)
        end

        it 'returns user data with ok status' do
          expect(response.status).to eq 200
          expect(json_response).to eq expected_json
        end
      end

      context 'pass existing phone number' do
        let(:errors_response) { { errors: 'Số điện thoại đã được đăng ký' } }

        before do
          expect {
            post :create, user: exist_user_signup_params
          }.to change { User.count }.by(0)
        end

        it 'returns errors response with unprocessable entity status' do
          expect(response.status).to eq 422
          expect(json_response).to eq errors_response.stringify_keys
        end
      end
    end
  end
end
