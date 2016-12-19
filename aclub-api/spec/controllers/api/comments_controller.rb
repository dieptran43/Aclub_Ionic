require 'rails_helper'

module Api
  describe CommentsController, api: true, set_api_authorized_headers: true do
    let(:coupon) { create(:coupon) }
    let!(:comments) { create_list(:comment, 3, commentable: coupon) }
    let(:comment_params) { { commentable_type: Coupon } }

    describe 'GET index' do
      let(:comment_ids) { json_response.map { |comment| comment['id'] } }

      it 'returns all comments of passing coupon' do
        get :index, comment: comment_params, coupon_id: coupon.id

        expect(response).to be_success
        expect(comment_ids).to match_array comments.map(&:id)
      end
    end

    describe 'POST create' do
      let(:content) { Faker::Lorem.sentence }
      let(:comment_params) { { commentable_type: Coupon, content: content, rate: rate } }

      context 'unsuccessfully' do
        let(:rate) { 100 }

        it 'renders errors' do
          expect {
            post :create, comment: comment_params, coupon_id: coupon.id
          }.not_to change { Comment.count }

          expect(json_response['errors']).to eq "Rate phải nằm trong khoảng 1..10"
        end
      end

      context 'successfully' do
        let(:rate) { (1..10).to_a.sample }

        it 'creates new comment record' do
          expect {
            post :create, comment: comment_params, coupon_id: coupon.id
          }.to change { Comment.count }.by(1)

          expect(json_response['content']).to eq content
          expect(json_response['rate']).to eq rate
        end
      end
    end
  end
end
