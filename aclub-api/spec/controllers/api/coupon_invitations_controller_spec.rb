require 'rails_helper'

module Api
  describe CouponInvitationsController, api: true, set_api_authorized_headers: true do
    let(:coupon_invitation_service) { double }
    let(:coupon_invitation_params) { { coupon_id: '1' } }
    let(:coupon_response_params) { { id: '1' } }

    describe 'POST create' do
      before do
        expect(CouponInvitationService).to receive(:new).with(coupon_invitation_params, user).and_return(coupon_invitation_service)
        expect(coupon_invitation_service).to receive(:create).and_return(create_status)
      end

      context 'successfully' do
        let(:create_status) { true }
        let(:mock_value) { Faker::Internet.name }
        let(:response_data) { { key: mock_value } }

        before do
          allow(coupon_invitation_service).to receive(:response_data).and_return(response_data)
          post :create, coupon_invitation: coupon_invitation_params
        end

        it 'returns ok' do
          expect(response).to be_success
          expect(json_response['key']).to eq mock_value
        end
      end

      context 'unsuccessfully' do
        let(:create_status) { false }
        let(:errors) { Faker::Internet.email }

        before do
          allow(coupon_invitation_service).to receive(:errors).and_return(errors)
          post :create, coupon_invitation: coupon_invitation_params
        end

        it 'returns errors response with unprocessable entity status' do
          expect(response.status).to eq 422
          expect(json_response['errors']).to eq errors
        end
      end
    end

    describe 'PUT update' do
      before do
        expect(CouponInvitationService).to receive(:new).with(coupon_response_params, user).and_return(coupon_invitation_service)
        expect(coupon_invitation_service).to receive(:update).and_return(update_status)
      end

      context 'successfully' do
        let(:update_status) { true }
        let(:mock_value) { Faker::Internet.name }
        let(:response_data) { { key: mock_value } }

        before do
          allow(coupon_invitation_service).to receive(:response_data).and_return(response_data)
          put :update, coupon_response_params
        end

        it 'returns ok' do
          expect(response).to be_success
          expect(json_response['key']).to eq mock_value
        end
      end

      context 'unsuccessfully' do
        let(:update_status) { false }
        let(:errors) { Faker::Internet.email }

        before do
          allow(coupon_invitation_service).to receive(:errors).and_return(errors)
          put :update, coupon_response_params
        end

        it 'returns errors response with unprocessable entity status' do
          expect(response.status).to eq 422
          expect(json_response['errors']).to eq errors
        end
      end
    end
  end
end
