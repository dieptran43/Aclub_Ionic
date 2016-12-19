require 'rails_helper'

module Api
  describe UsersController, api: true, set_api_authorized_headers: true do

    describe 'GET friends' do
      let!(:user_1) { create(:user, phone: '84989121233') }
      let!(:user_2) { create(:user, phone: '84989121234') }
      let!(:user_3) { create(:user, phone: '84989121235') }
      let(:following_user_ids) { json_response['followings'].map { |user| user['id'] } }
      let(:follower_user_ids) { json_response['followers'].map { |user| user['id'] } }

      before do
        user.follow(user_1)
        user.follow(user_2)
        user_2.follow(user)

        get :friends, id: user.to_param
      end

      it 'returns all following/follower users' do
        expect(response).to be_success
        expect(user.following_user_ids).to match_array following_user_ids
        expect(user.user_followers.pluck(:id)).to match_array follower_user_ids
      end
    end

    describe 'GET available_coupons' do
      context 'returns available coupons' do
        let(:coupon_1) { create(:coupon) }
        let(:coupon_2) { create(:coupon) }
        let(:coupon_3) { create(:coupon, end_date: 1.days.ago) }
        let(:coupon_ids) { json_response.map { |coupon| coupon['id'] } }

        before do
          user.user_coupons.find_or_create_by(coupon: coupon_1)
          user_coupon_2 = user.user_coupons.find_or_create_by(coupon: coupon_2)
          user.user_coupons.find_or_create_by(coupon: coupon_3)
          user_coupon_2.used!
        end

        it 'returns available coupons' do
          post :available_coupons, id: user.to_param
          expect(response).to be_success
          expect(coupon_ids).to eq [coupon_1.id]
        end
      end
    end

    describe 'GET invitees' do
      let(:coupon) { create(:coupon) }
      let!(:user_1) { create(:user, phone: '84969032261') }
      let!(:user_2) { create(:user, phone: '84969032262') }
      let!(:user_3) { create(:user, phone: '84969032263') }
      let(:pending_ids) { json_response["pending_invitees"].map { |user| user['id'] } }
      let(:accepted_ids) { json_response["accepted_invitees"].map { |user| user['id'] } }
      let(:denied_ids) { json_response["denied_invitees"].map { |user| user['id'] } }

      before do
        user.coupon_invitation_invitees.find_or_create_by(invitee: user_1, coupon: coupon, status: "pending")
        user.coupon_invitation_invitees.find_or_create_by(invitee: user_2, coupon: coupon, status: "accepted")
        user.coupon_invitation_invitees.find_or_create_by(invitee: user_3, coupon: coupon, status: "denied")
      end

      it 'returns invitees' do
        get :invitees, { id: user.id, coupon_id: coupon.id,  }

        expect(response).to be_success
        expect(pending_ids).to match_array [user_1.id]
        expect(accepted_ids).to match_array [user_2.id]
        expect(denied_ids).to match_array [user_3.id]
      end
    end

    describe 'GET used_coupons' do
      context 'returns available coupons' do
        let(:coupon_1) { create(:coupon) }
        let(:coupon_2) { create(:coupon) }
        let(:coupon_3) { create(:coupon, end_date: 1.days.ago) }
        let(:coupon_ids) { json_response.map { |coupon| coupon['id'] } }

        before do
          user.user_coupons.find_or_create_by(coupon: coupon_1)
          user_coupon_2 = user.user_coupons.find_or_create_by(coupon: coupon_2)
          user_coupon_3 = user.user_coupons.find_or_create_by(coupon: coupon_3)
          user_coupon_2.used!
          user_coupon_3.used!
        end

        it 'returns used coupons' do
          post :used_coupons, id: user.to_param
          expect(response).to be_success
          expect(coupon_ids).to eq [coupon_2.id, coupon_3.id]
        end
      end
    end

    describe 'PUT update' do
      let(:user_service) { double }

      before do
        expect(::Api::UserService).to receive(:new).with(user, update_params).and_return(user_service)
        expect(user_service).to receive(:update).and_return(update_status)
      end

      context 'update successfully' do
        let(:response_data) { { token: Faker::Lorem.characters(8) } }
        let(:update_status) { true }

        before do
          expect(user_service).to receive(:response_data).and_return(response_data)
        end

        context 'update all attributes' do
          let(:update_params) {
            {
              name: Faker::Name.name,
              email: Faker::Internet.email
            }
          }

          it 'returns user response with ok status' do
            post :update, id: user.to_param, user: update_params

            expect(response.status).to eq 200
            expect(json_response).to eq response_data.stringify_keys
          end
        end
      end

      context 'update unsuccessfully' do
        let(:update_params) { { email: Faker::Internet.email } }
        let(:errors_response) { { errors: 'Error' } }
        let(:update_status) { false }

        before do
          expect(user_service).to receive(:errors).and_return(errors_response)

          post :update, id:user.to_param, user: update_params
        end

        it 'returns errors response with unprocessable entity status' do
          expect(response.status).to eq 422
          expect(json_response).to eq errors_response.stringify_keys
        end
      end
    end

    describe 'POST email_registration' do
      let(:password) { 'password' }
      let(:email) { Faker::Internet.email }
      let(:user) { create(:user) }
      let(:params) { { id: user.id, email: email, password: password } }

      it 'should generate email verification token and unverified email for user' do
        post :email_registration, params

        expect(user.reload.unverified_email).to eq email
        expect(user.reload.email_verification_token).not_to eq nil
      end
    end

    describe 'POST email_verification' do
      let(:email_token) { Faker::Lorem.word }
      let(:email) { Faker::Internet.email }
      let(:user) { create(:user, unverified_email: email, email_verification_token: email_token) }

      context 'valid email token' do
        let(:params) { { id: user.id, email_token: email_token } }

        it 'should update user email and clear unverified_email and email_verification_token' do
          post :email_verification, params

          expect(user.reload.unverified_email).to eq nil
          expect(user.reload.email_verification_token).to eq nil
          expect(user.reload.email).to eq email
        end
      end

      context 'invalid email token' do
        let(:params) { { id: user.id, email_token: '' } }

        it 'should return unauthorized erro' do
          post :email_verification, params

          expect(user.reload.unverified_email).to eq email
          expect(user.reload.email_verification_token).not_to eq nil
          expect(user.reload.email).to eq nil
          expect(response.status).to eq 401
        end
      end
    end

    describe 'GET show' do
      pending "add some examples to (or delete) #{__FILE__}"
    end
  end
end
