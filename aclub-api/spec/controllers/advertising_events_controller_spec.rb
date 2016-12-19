require 'rails_helper'
#this controller is temporarily disable
RSpec.describe AdvertisingEventsController, type: :controller do
  # let(:user) { create(:user) }
  # let(:response_body) { JSON.parse(response.body) }
  # let!(:advertising_event) { create(:advertising_event) }

  # describe 'GET #home' do
  #   it 'should show home page and return ok status' do
  #     get :home
  #     expect(response.status).to eq 200
  #   end
  # end

  # describe 'GET #thank_you' do
  #   it 'should show thank_you page and return ok status' do
  #     get :thank_you, email: user.email
  #     expect(response.status).to eq 200
  #     expect(assigns(:user)).to eq user
  #   end
  # end

  # describe 'GET #omniauth_callback' do
  #   subject { get :omniauth_callback, provider: 'facebook' }

  #   let(:omniauth_service) { double }
  #   before do
  #     allow(OmniauthService).to receive(:new).and_return(omniauth_service)
  #     allow(omniauth_service).to receive(:authenticate_user).and_return(authenticate_result)
  #   end

  #   context 'successfully authenticate user by facebook' do
  #     let(:authenticate_result) { user }

  #     it 'should redirect user to registration phone page' do
  #       expect(subject).to redirect_to(action: :phone_registration_page, email: user.email, token: user.facebook_token)
  #     end
  #   end

  #   context 'unsuccessfully authenticate user by facebook' do
  #     let(:authenticate_result) { nil }

  #     it 'should redirect user to omniauth fallback page' do
  #       expect(subject).to redirect_to(action: :omniauth_fallback)
  #     end
  #   end
  # end

  # describe 'GET #omniauth_fallback' do
  #   it 'should show omniauth_fallback page and return ok status' do
  #     get :omniauth_fallback
  #     expect(response.status).to eq 200
  #   end
  # end

  # describe 'GET #phone_registration_page' do
  #   let(:user) { create(:user, email: Faker::Internet.email, facebook_token: Faker::Lorem.word )}

  #   context 'invalid facebook credential' do
  #     subject { get :phone_registration_page }

  #     it 'should redirect to home page' do
  #       expect(subject).to redirect_to(action: :home)
  #     end
  #   end

  #   context 'valid facebook credential' do
  #     subject { get :phone_registration_page, params }

  #     context 'user did not join the event' do
  #       let(:params) { { email: user.email, token: user.facebook_token, advertising_event_id: advertising_event.id } }

  #       it 'should render phone_registration page' do
  #         expect(subject).to render_template(:phone_registration_page)
  #       end
  #     end

  #     context 'user joined and win the event' do
  #       let(:advertising_event) { create(:advertising_event, winning_rate: 1.0, maximum_number_of_winners: 10) }
  #       let!(:user_advertising_event) { create(:user_advertising_event, user: user, advertising_event: advertising_event) }
  #       let(:params) { { email: user.email, token: user.facebook_token, advertising_event_id: advertising_event.id } }

  #       it 'should redirect_to reward page' do
  #         expect(subject).to redirect_to(action: :reward, email: user.email, token: user.facebook_token, advertising_event_id: advertising_event.id)
  #       end
  #     end

  #     context 'user joined but did not win the event' do
  #       let(:advertising_event) { create(:advertising_event, winning_rate: 0.0, maximum_number_of_winners: 10) }
  #       let!(:user_advertising_event) { create(:user_advertising_event, user: user, advertising_event: advertising_event) }
  #       let(:params) { { email: user.email, token: user.facebook_token, advertising_event_id: advertising_event.id } }

  #       it 'should redirect_to thank_you page' do
  #         expect(subject).to redirect_to(action: :thank_you, advertising_event_id: advertising_event.id, email: user.email)
  #       end
  #     end
  #   end
  # end

  # describe 'POST #register_phone' do
  #   let(:phone) { '1234' }
  #   let(:params) { { email: user.email, token: user.facebook_token, phone: phone } }
    
  #   context 'there is no existing user using the registering phone' do
  #     context 'update phone_number successfully' do
  #       it 'should return ok reponse and send sms to user' do
  #         allow_any_instance_of(User).to receive(:update_attributes).with({ phone: phone, name: nil }).and_return(true)
  #         expect(PhoneVerificationJob).to receive(:perform_later).with(user.id).and_call_original
  #         post :register_phone, params

  #         expect(response.status).to eq 200
  #       end
  #     end

  #     context 'update phone_number unsuccessfully' do
  #       it 'should return error messages' do
  #         post :register_phone, params

  #         expect(response.status).to eq 422
  #         expect(response_body["messages"]).to include "#{I18n.t('activerecord.attributes.user.phone')} #{I18n.t('activerecord.errors.models.user.attributes.phone.invalid')}"
  #       end
  #     end
  #   end

  #   context 'there is an user using the registering phone already' do
  #     let(:new_user) { build(:user, phone: nil, email: Faker::Internet.email) }
  #     let!(:existing_user) { create(:user, phone: '84972479830') }
  #     let(:params) { { email: new_user.email, token: new_user.facebook_token, phone: '0972479830' } }

  #     it 'should merge newly created user to old user' do
  #       new_user.save(validate: false)
  #       new_user_id = new_user.id
  #       post :register_phone, params

  #       expect(response.status).to eq 200
  #       expect(existing_user.reload.facebook_token).to eq new_user.facebook_token
  #       expect(existing_user.reload.email).to eq new_user.email
  #       expect(User.find_by_id(new_user.id)).to eq nil
  #     end
  #   end
  # end

  # describe 'POST #verify_phone' do
  #   let(:params) { { email: user.email, token: user.facebook_token, verification_token: verification_token, advertising_event_id: advertising_event.id } }

  #   context 'user input valid phone verification token' do
  #     let(:verification_token) { user.verification_token }

  #     context 'record user registration for the event successfully' do
  #       it 'should return ok status and winning status' do
  #         allow_any_instance_of(UserAdvertisingEvent).to receive(:save).and_return(true)
  #         post :verify_phone, params

  #         expect(response.status).to eq 200
  #         expect(response_body.keys).to include "win"
  #       end
  #     end

  #     context 'record user registration for the event unsuccessfully' do
  #       it 'should return errors message' do
  #         allow_any_instance_of(UserAdvertisingEvent).to receive(:save).and_return(false)
  #         post :verify_phone, params

  #         expect(response.status).to eq 422
  #         expect(response_body["messages"]).to eq I18n.t('advertising_event.general_error')
  #       end
  #     end
  #   end

  #   context 'user input wrong phone verification token' do
  #     let(:verification_token) { Faker::Lorem.word }

  #     it 'should return errors message' do
  #       post :verify_phone, params

  #       expect(response.status).to eq 422
  #       expect(response_body["messages"]).to eq I18n.t('advertising_event.invalid_verification_code')
  #     end
  #   end
  # end

  # describe 'POST #resend_phone_token' do
  #   let(:params) { { email: user.email, token: user.facebook_token } }

  #   it 'should return ok reponse and send sms to user' do
  #       expect(PhoneVerificationJob).to receive(:perform_later).with(user.id).and_call_original
  #       post :resend_phone_token, params

  #       expect(response.status).to eq 200
  #     end
  # end
end
