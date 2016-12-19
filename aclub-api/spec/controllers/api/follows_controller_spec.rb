require 'rails_helper'

module Api
  RSpec.describe FollowsController, type: :controller, api: true, set_api_authorized_headers: true do
    describe 'POST create' do
      let(:followable) { create(:user, phone: '84989471288') }
      let(:followable_id) { followable.id }
      let(:follow_params) { { followable_id: followable_id, followable_type: followable.class.to_s } }

      before do
        post :create, follow: follow_params
      end

      context 'follow successfully' do
        context 'user already follow passed object' do
          before do
            user.follow(followable)
          end

          it 'returns ok status' do
            expect(response.status).to eq 200
            expect(user).to be_following followable
          end
        end

        context 'user havent followed passed object yet' do
          it 'returns ok status' do
            expect(response.status).to eq 200
            expect(user).to be_following followable
          end
        end
      end

      context 'follow unsuccessfully' do
        context 'pass non existing followable' do
          let(:followable_id) { followable.id + 1 }

          it 'returns errors response with not found status' do
            expect(response.status).to eq 404
          end
        end
      end
    end

    describe 'DELETE destroy' do
      pending "add some examples to (or delete) #{__FILE__}"
    end
  end
end
