require 'rails_helper'

module Api
  describe SessionsController, api: true do

    describe '#create', set_api_headers: true do
      let(:valid_signin_params) { { phone: user.phone, verification_token: user.verification_token } }
      let(:invalid_signin_params) { { phone: user.phone, verification_token: 'faker' } }

      context 'pass valid data' do
        let(:expected_json) { {
          "id" => user.id,
          "name" => user.name,
          "email" => user.email,
          "email_verification_token" => user.email_verification_token,
          "phone" => user.phone,
          "avatar" => {},
          "token" => user.authentication_token.token,
          "unverified_email" => user.unverified_email,
          "available_coupons" => [],
          "used_coupons" => []
        } }

        before do
          post :create, user: valid_signin_params
        end

        it 'returns user data with ok status' do
          expect(response.status).to eq 200
          expect(json_response).to eq expected_json
        end
      end

      context 'pass invalid data' do
        let(:errors_response) { { errors: I18n.t('controller.users.invalid_verification_code') } }

        before do
          post :create, user: invalid_signin_params
        end

        it 'returns errors response with unprocessable entity status' do
          expect(response.status).to eq 401
          expect(json_response).to eq errors_response.stringify_keys
        end
      end
    end

    describe '#request_phone_verification_token', set_api_headers: true do
      context 'successfully create new verification token' do
        let!(:old_verification_token) { user.verification_token }
        let(:params) { { user: { phone: user.phone} } }

        it 'creates new verification_token for user' do
          post :request_phone_verification_token, params
          expect(response.status).to eq 200
          expect(user.reload.verification_token).not_to eq old_verification_token
        end
      end
    end
  end
end
