require 'rails_helper'

module Api
  RSpec.describe ThirdPartyAccountService do
    describe '#create' do
      subject { described_class.new(params) }
      let(:device_token) { Faker::Lorem.characters(64) }
      let(:provider) { ThirdPartyAccountProvider::Facebook }
      let(:uid) { 10202342249541124 }
      let(:email) { Faker::Internet.email }
      let(:user_agent) { 'ios' }
      let(:params) { { uid: uid, provider: provider, access_token: Faker::Lorem.characters(64), device_token: device_token, phone: User.first.try(:phone) } }
      let(:facebook_response) { {
        'id' => uid,
        'email' => email,
        'name' => Faker::Name.name
      } }
      let(:picture_url) { nil }

      context 'create successfully' do
        before do
          allow_any_instance_of(Koala::Facebook::API).to receive(:get_object).and_return(facebook_response)
          expect_any_instance_of(Koala::Facebook::API).to receive(:get_picture).with(uid, type: :large).and_return(picture_url)
        end

        context 'non-existing user' do
          let(:params) { { uid: uid, provider: provider, access_token: Faker::Lorem.characters(64), device_token: device_token, phone: "84972479830", user_agent: user_agent } }
          before do
            expect_any_instance_of(User).to receive(:add_device_token).with(device_token, user_agent)
          end

          it 'creates devices with the new token' do
            expect(subject.create).to be_truthy
          end
        end

        context 'existing user' do
          let!(:existing_user) { create(:user, email: email) }

          it 'link user with new identity' do
            expect(subject.create).to be_truthy
            expect(Identity.find_by_uid(uid).user).to eq existing_user
          end
        end
      end

      context 'create unsuccessfully' do
        context 'missing identity parameters' do
          let(:params) { {} }

          it 'return false with errors' do
            expect(subject.create).to be_falsey
            expect(subject.errors).to eq(I18n.t("base.api.third_party.missing_parametters"))
          end
        end

        context "can't fetch user info" do
          before do
            allow_any_instance_of(Koala::Facebook::API).to receive(:get_object).and_raise(Koala::KoalaError)
          end

          it 'returns false' do
            expect(subject.create).to be_falsey
          end
        end
      end
    end
  end
end
