require 'rails_helper'

RSpec.describe PhoneVerificationJob do
  describe '.perform' do

    context 'user exist' do
      let!(:user) { create(:user) }

      it 'should send user message' do
        expect(Api::SMS).to receive(:send_message).with(user)
        PhoneVerificationJob.new.perform(user.id)
      end
    end

    context 'user does not exist' do
      it 'should not send any message' do
        expect(Api::SMS).to_not receive(:send_message)
        PhoneVerificationJob.new.perform(nil)
      end
    end
  end
end
