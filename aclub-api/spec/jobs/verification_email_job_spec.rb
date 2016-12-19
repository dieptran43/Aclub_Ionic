require 'rails_helper'

RSpec.describe VerificationEmailJob do
  describe '.perform' do
    context 'user exist and have unverfied email' do
      let!(:user) { create(:user, unverified_email: Faker::Internet.email) }
      let(:mail) { double(UserMailer) }

      it 'should send user verificartion email' do
        expect(UserMailer).to receive(:send_email_verification_code).with(user.email_verification_token, user.unverified_email).and_return(mail)
        expect(mail).to receive(:deliver_now)
        VerificationEmailJob.new.perform(user.id)
      end
    end
  end
end