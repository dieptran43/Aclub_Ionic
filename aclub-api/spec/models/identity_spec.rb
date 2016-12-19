require 'rails_helper'

RSpec.describe Identity, type: :model do
  describe 'relationships' do
    it { is_expected.to belong_to(:user) }
  end

  describe 'validations' do
    it { is_expected.to validate_presence_of(:uid) }
    it { is_expected.to validate_uniqueness_of(:uid) }
  end

  describe '.find_for_auth' do
    let(:provider) { ThirdPartyAccountProvider::Facebook }
    let(:type) { FacebookIdentity.to_s }

    context 'with existing identity' do
      let(:access_token) { Faker::Lorem.characters(16) }
      let(:identity) { create(:identity, type: type) }
      let(:auth) { { uid: identity.uid, provider: provider, access_token: access_token } }

      it 'updates matched identity info then return' do
        identity = type.constantize.find_for_auth(auth)
        expect(identity.id).to eq identity.id
        expect(identity.access_token).to eq access_token
        expect(identity).to_not be_changed
      end
    end

    context 'with non existing identity' do
      let(:auth) { { uid: 'SAMPLE_UID', provider: 'SAMPLE_PROVIDER' } }

      it 'initialize new identity with passing params' do
        newly_identity = type.constantize.find_for_auth(auth)
        expect(newly_identity).to be_new_record
        expect(newly_identity.uid).to eq auth[:uid]
      end
    end
  end

  describe '.initialize_with_parameters' do
    let(:parameters) { {
      uid: Faker::Lorem.characters(16),
      provider: provider
    } }

    context 'does not sufficient identity info' do
      let(:parameters) { { } }

      it 'return nil' do
        expect(Identity.initialize_with_parameters(parameters)).to be_nil
      end
    end

    context 'sufficient identity info' do
      context 'provider is facebook' do
        let(:provider) { ThirdPartyAccountProvider::Facebook }

        it 'return FacebookIdentity object' do
          expect(Identity.initialize_with_parameters(parameters).class).to eq FacebookIdentity
        end
      end

      context 'others' do
        let(:provider) { 'others' }

        it 'return nil' do
          expect(Identity.initialize_with_parameters(parameters)).to be_nil
        end
      end
    end
  end

  describe '#fetch_data' do
    let(:identity) { build(:facebook_identity, uid: uid, access_token: access_token, access_token_secret: access_token_secret, type: type) }
    let(:uid) { "10202342249541124" }
    let(:access_token) { Faker::Lorem.characters(64) }
    let(:access_token_secret) { Faker::Lorem.characters(64) }
    let(:email) { Faker::Internet.email }
    let(:name) { Faker::Name.name }
    let(:facebook_response) { {
      id: uid,
      email: email,
      name: name
    } }
    let(:picture_url) { "faker" }

    context 'successfully' do
      let(:type) { FacebookIdentity.to_s }
      let(:provider) { ThirdPartyAccountProvider::Facebook }
      let(:subject) { identity.fetch_data }

      before do
        allow_any_instance_of(Koala::Facebook::API).to receive(:get_object).and_return(facebook_response)
        expect_any_instance_of(Koala::Facebook::API).to receive(:get_picture).with(uid, type: :large).and_return(picture_url)
      end

      it 'returns user data' do
        expect(subject[:profile_picture]).to eq picture_url
        expect(subject[:email]).to eq email
        expect(subject[:name]).to eq name
      end
    end

    context 'unsuccessfully' do
      context 'facebook' do
        let(:type) { FacebookIdentity.to_s }
        let(:provider) { ThirdPartyAccountProvider::Facebook }

        context 'missing access_token' do
          let(:access_token) { nil }

          it 'returns nil with errors' do
            expect(identity.fetch_data).to be_nil
            expect(identity.errors.any?).to be_truthy
          end
        end

        context "can't fetch data from Facebook" do
          before do
            allow_any_instance_of(Koala::Facebook::API).to receive(:get_object).and_raise(Koala::KoalaError)
          end

          it 'returns nil with errors' do
            expect(identity.fetch_data).to be_nil
            expect(identity.errors.any?).to be_truthy
          end
        end

        context "doesn't match uid" do
          let(:uid) { "102023422495411241" }

          before do
            allow_any_instance_of(Koala::Facebook::API).to receive(:get_object).and_return(facebook_response)
          end

          it 'returns nil with errors' do
            expect(identity.fetch_data).to be_nil
            expect(identity.errors.any?).to be_truthy
          end
        end
      end
    end
  end
end
