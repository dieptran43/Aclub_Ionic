class AdvertisingEventsController < ApplicationController
  layout 'advertising'

  before_filter :facebook_authenticate, only: [:phone_registration_page, :register_phone, :verify_phone, :resend_phone_token, :reward]
  before_filter :required_enabled_advertising_event, only: [:phone_registration_page, :verify_phone]

  def show
    @advertising_event = AdvertisingEvent.friendly.find(params[:id])
  end

  def omniauth_callback
    advertising_event_id = request.env['omniauth.params']['advertising_event_id'] if request.env['omniauth.params']
    omniauth_service = OmniauthService.new(request.env['omniauth.auth'])
    if user = omniauth_service.authenticate_user
      redirect_to action: :phone_registration_page, token: user.facebook_token, email: user.email, advertising_event_id: advertising_event_id
    else
      redirect_to action: :omniauth_fallback
    end
  end

  def phone_registration_page
    @advertising_event = AdvertisingEvent.find_by_id(params[:advertising_event_id])
    if @current_user.joined?(@advertising_event)
      if @current_user.is_winner?(@advertising_event)
        redirect_to action: :reward, email: @current_user.email, token: @current_user.facebook_token, advertising_event_id: @advertising_event.id
      else
        redirect_to action: :thank_you, email: @current_user.email, advertising_event_id: @advertising_event.id
      end
    else
      if @current_user.phone
        PhoneVerificationJob.perform_later(@current_user.id)
      end
    end
  end

  def register_phone
    if existing_user = User.find_by_phone(Api::PhoneParser.normalize(params[:phone]))
      existing_user.facebook_token = @current_user.facebook_token
      existing_user.facebook_token_expiration = @current_user.facebook_token_expiration
      existing_user.facebook_image_url = @current_user.facebook_image_url
      existing_user.email = @current_user.email
      ActiveRecord::Base.transaction do
        @current_user.destroy unless @current_user.id == existing_user.id
        existing_user.save
      end
      PhoneVerificationJob.perform_later(existing_user.id)
      head :ok
    else
      if @current_user.update_attributes(phone: params[:phone], name: params[:name])
        PhoneVerificationJob.perform_later(@current_user.id)
        head :ok
      else
        render json: { messages: @current_user.errors.full_messages }, status: :unprocessable_entity
      end
    end
  end

  def verify_phone
    if @current_user.verification_token == params[:verification_token]
      certificate = UserAdvertisingEvent.new(advertising_event_id: params[:advertising_event_id], user: @current_user)

      if certificate.save
        render json: { win: certificate.won? }
      else
        render json: { messages: I18n.t('advertising_event.general_error') }, status: :unprocessable_entity
      end
    else
      render json: { messages: I18n.t('advertising_event.invalid_verification_code') }, status: :unprocessable_entity
    end
  end

  def resend_phone_token
    PhoneVerificationJob.perform_later(@current_user.id)
    head :ok
  end

  def thank_you
    @user = User.find_by_email(params[:email])
    @advertising_event = AdvertisingEvent.find_by_id(params[:advertising_event_id])
  end

  def reward
    @advertising_event = AdvertisingEvent.find_by_id(params[:advertising_event_id])
  end

  private
  def facebook_authenticate
    unless (@current_user = User.find_by_email(params[:email])) && (@current_user.facebook_token == params[:token])
      redirect_to action: :home
    end
  end

  def required_enabled_advertising_event
    @advertising_event = AdvertisingEvent.find_by_id(params[:advertising_event_id])
    unless @advertising_event.try(:enabled)
      if @advertising_event
        redirect_to action: :show, id: @advertising_event.slug
      else
        redirect_to action: :show, id: "not-found"
      end
    end
  end
end
