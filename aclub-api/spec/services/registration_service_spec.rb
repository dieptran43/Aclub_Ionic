require 'rails_helper'

module Api
  RSpec.describe RegistrationService do
    let(:device_token) { Random.rand(5) }
    let(:phone) { "84972439830" }
    let(:user_agent) { 'ios' }
    let(:params) { { phone: phone, device_token: device_token, user_agent: user_agent } }
    let(:registration_service) { RegistrationService.new(params) }

    describe '#initialize' do
      let(:signup_params) { { phone: phone } }

      it 'should create new registration service instance with passed params' do
        expect(registration_service.signup_params).to eq signup_params
        expect(registration_service.user_agent).to eq user_agent
        expect(registration_service.device_token).to eq device_token
      end
    end

    describe '#create' do
      context 'valid user registration params' do
        it 'should create user and add logged in device to newly created user' do
          expect(registration_service.create).to eq true
          user = User.find_by_phone(phone)
          expect(user.devices.map(&:user_agent)).to include user_agent          
        end
      end

      context 'invalud user registration params' do
        let(:phone) { "invalid phone" }

        it 'should not create user nor device' do
          expect(registration_service.create).to eq false
          expect(User.find_by_phone(phone)).to be nil
        end
      end
    end

    describe '#response_data' do
      let(:user) { double(User) }
      let(:unauthorized_user_presenter) { double(UnauthorizedUserPresenter) }
      it 'should return an instance of unauthorize user presenter' do
        allow(registration_service).to receive(:user).and_return(user)
        allow(UnauthorizedUserPresenter).to receive(:new).with(user).and_return(unauthorized_user_presenter)

        expect(registration_service.response_data).to eq unauthorized_user_presenter
      end
    end

    describe '#errors' do
      let(:user) { double(User) }
      let(:model_errors_presenter) { double(ModelErrorsPresenter) }
      it 'should return an instance of unauthorize user presenter' do
        allow(registration_service).to receive(:user).and_return(user)
        allow(ModelErrorsPresenter).to receive(:new).with(user).and_return(model_errors_presenter)

        expect(registration_service.errors).to eq model_errors_presenter
      end
    end
  end
end