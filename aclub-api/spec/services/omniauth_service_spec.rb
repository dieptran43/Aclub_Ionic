require 'rails_helper'

RSpec.describe OmniauthService do
  let(:omniauth_info) { OpenStruct.new(
    info: OpenStruct.new({ email: Faker::Internet.email, name: Faker::Internet.name, image: Faker::Internet.url }),
    credentials: OpenStruct.new({ token: Faker::Lorem.word, expires_at: 1.day })
  )}
  let(:service) { OmniauthService.new(omniauth_info) }

  describe '#authenticate_user' do
    context 'there is no user in the system with email provided by facebook and user save successfully' do
      it 'should return created user' do
        expect{ @user = service.authenticate_user }.to change{ User.count }.by(1)
        expect(@user.email).to eq omniauth_info.info.email
        expect(@user.facebook_token).to eq omniauth_info.credentials.token
        expect(@user.facebook_token_expiration).to eq omniauth_info.credentials.expires_at
      end
    end

    context 'there is an user in the system with email provided by facebook and user save successfully' do
      let!(:existing_user) { create(:user, email: omniauth_info.info.email) }
      it 'should return the user' do
        expect{ @user = service.authenticate_user }.to change{ User.count }.by(0)
        expect(@user.email).to eq existing_user.email
        expect(@user.facebook_token).to eq omniauth_info.credentials.token
        expect(@user.facebook_token_expiration).to eq omniauth_info.credentials.expires_at
      end
    end

   context 'update new token unsuccessfully' do
      it 'should return nil' do
        allow_any_instance_of(User).to receive(:save).with(validate: false).and_return(false)
        expect(service.authenticate_user).to eq nil
      end
    end
  end
end
