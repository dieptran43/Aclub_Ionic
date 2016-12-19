require 'rails_helper'

module Facebook
  describe FacebookVoucherService do
    describe "check_number" do
      let!(:advertising_event1) { create(:advertising_event, winning_rate: 0.0, maximum_number_of_winners: 10)}
      let!(:advertising_event2) { create(:advertising_event, winning_rate: 0.0, maximum_number_of_winners: 10, url: 'test url')}


      context 'user has registered in system before' do
        let!(:user) { create(:user, phone: '84912345678')}
        context 'user has taken advertising event before' do
          let!(:user_advertising_event) { create(:user_advertising_event, user: user, advertising_event: advertising_event1) }

          it 'return status code 1 with corresponding registered user advertising event' do
            params = {:user => { :phone => '84912345678', :coupon_id => advertising_event1.id }}
            service_object = described_class.new(params)
            result = service_object.check_number()
            expect(result[:status]).to eq 1
          end
        end

        context 'user has NOT taken advertising event before' do
          let!(:params) { {user: { phone: '84912345678', coupon_id: advertising_event2.id }}}
          it 'return code 200 and show status of recent registered user advertising event' do
            service_object = described_class.new(params)
            result = service_object.check_number()
            expect(result[:status]).to eq 1
          end
        end
      end

      context 'user has not registered in system before' do
        context 'user input malform phone number' do
          let!(:params) { {user: { phone: '12345', coupon_id: advertising_event1.id }}}

          it 'return code 200 and show error' do
            service_object = described_class.new(params)
            result = service_object.check_number()
            expect(result[1][:status]).to eq :unprocessable_entity
          end
        end

        context 'user input available number' do
          let!(:params) { {user: { phone: '84968253741', coupon_id: advertising_event1.id }}}

          it 'return code 0 and show user has been registered successfully' do
            service_object = described_class.new(params)
            result = service_object.check_number()
            expect(result[:status]).to eq 0
          end
        end
      end
    end
  end
end