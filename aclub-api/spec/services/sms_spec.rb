require 'rails_helper'

module Api
  RSpec.describe SMS do
    describe '.send_message' do
      let(:viettle_user) { build(:user, phone: '84972479830') }
      let(:other_user) { build(:user, phone: '94999999999') }

      context 'sending message to viettle user' do
        let(:content_message) { "Ma xac nhan AClub cua ban la: #{viettle_user.verification_token}" }
        let(:expected_message) {{
          'User' => 'bulk_bienbinh',
          'Password' => Rails.application.secrets.viettel_bulk_sms_password,
          'CPCode' => 'BIENBINH',
          'ServiceID' => 'ACLUB',
          'RequestID' => 4,
          'CommandCode' => 'bulksms',
          'UserID' => viettle_user.phone,
          'ReceiverID' => viettle_user.phone,
          'Content' => content_message,
          'ContentType' => 'F'
        }}

        it 'should using Savon soap client to send request to viettle sms server' do
          expect_any_instance_of(Savon::Client).to receive(:call).with(:ws_cp_mt, message: expected_message)
          SMS.send_message(viettle_user)
        end
      end

      context 'sending message to other carrier user' do
        let(:content_message) { "Ma xac nhan AClub cua ban la: #{other_user.verification_token}" }

        it 'should use http client to send request to sms gateway' do
          expect_any_instance_of(Net::HTTP).to receive(:request)
          SMS.send_message(other_user)
        end
      end
    end
  end
end
