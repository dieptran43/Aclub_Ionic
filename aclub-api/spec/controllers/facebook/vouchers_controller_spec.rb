require 'rails_helper'

module Facebook
  describe VouchersController, type: :controller do
    render_views

    describe "GET #index" do
      it 'should show voucher home page and return ok status' do
        get :index
        expect(response.status).to eq 200
      end
    end

    describe 'POST send_sms' do
      let!(:user) { create(:user, phone: '84912345678')}
      context 'user number has been registered before' do
        let!(:params) { {user: { phone: user.phone}}}
        it 'return status 200' do
          post :send_sms, params
          expect(response.status).to eq 200
        end
      end

      context 'user number has NOT been registered before' do
        let!(:params) { {user: { phone: user.phone+'123'}}}
        it 'return status 404' do
          post :send_sms, params
          expect(response.status).to eq 404
        end
      end
    end

    describe "POST registration" do
      let!(:advertising_event1) { create(:advertising_event, winning_rate: 0.0, maximum_number_of_winners: 10)}
      let!(:advertising_event2) { create(:advertising_event, winning_rate: 0.0, maximum_number_of_winners: 10, url: 'test url')}


      context 'user has registered in system before' do
        let(:user) { create(:user, phone: '84912345678')}
        let!(:user_advertising_event) { create(:user_advertising_event, user: user, advertising_event: advertising_event1) }

        context 'user has taken advertising event before' do
          let!(:params) { {user: { phone: '84912345678', coupon_id: advertising_event1.id }}}
          it 'return code 200 and show status of registered user advertising event' do
            post :registration, params
            expect(response.status).to eq 200
            expect(response.content_type).to eq("application/json")
            parsed_body = JSON.parse(response.body)
            expect(parsed_body['status']).to eq(1)
          end
        end

        context 'user has NOT taken advertising event before' do
          let!(:params) { {user: { phone: '84912345678', coupon_id: advertising_event2.id }}}
          it 'return code 200 and show status of recent registered user advertising event' do
            post :registration, params
            expect(response.status).to eq 200
            expect(response.content_type).to eq("application/json")
            parsed_body = JSON.parse(response.body)
            expect(parsed_body['status']).to eq(1)
          end
        end
      end

      context 'user has not registered in system before' do
        context 'user input malform phone number' do
          let!(:params) { {user: { phone: '12345', coupon_id: advertising_event1.id }}}

          it 'return code 200 and show error' do
            post :registration, params
            expect(response.status).to eq 200
            expect(response.content_type).to eq("application/json")
            parsed_body = JSON.parse(response.body)
            expect(parsed_body[1]['status']).to eq('unprocessable_entity')
          end
        end

        context 'user input available number' do
          let!(:params) { {user: { phone: '84968253741', coupon_id: advertising_event1.id }}}

          it 'return code 200 and show user has been registered successfully' do
            post :registration, params
            expect(response.status).to eq 200
            expect(response.content_type).to eq("application/json")
            parsed_body = JSON.parse(response.body)
            expect(parsed_body['status']).to eq(0)
          end
        end
      end
    end

  end
end