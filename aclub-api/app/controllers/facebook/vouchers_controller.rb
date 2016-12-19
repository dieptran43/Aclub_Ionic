module Facebook
  class VouchersController < ApplicationController
    include Api
    skip_before_filter :verify_authenticity_token
    before_filter :allow_iframe_requests

    def index
      @available_voucher = AdvertisingEvent.where(enabled: true).current.order('updated_at DESC')
      @partners = Partner.where(active: true).order('"order" ASC')
      render :layout => 'voucher_tab'
    end

    def startpage
    end

    def registration
      voucher_service =  FacebookVoucherService.new(params)
      return_data = voucher_service.check_number
      render json: return_data
    end

    def send_sms
      normalized_phone = Api::PhoneParser.normalize(params[:user][:phone])
      if user = User.find_by_phone(normalized_phone)
        user.generate_phone_verification_token
        user.save
        user.send_verification_code
        head :ok
      else
        render json: { :errors => 'Hệ thống không tìm thấy người dùng' }, status: :not_found
      end
    end

    def restaurant_advertising_event
      if params[:signed_request]
        session[:signed_request] = FacebookVoucherService.decode_facebook_hash(params[:signed_request])
        @available_voucher = AdvertisingEvent.get_by_owner_fanpage_id(session[:signed_request]['page']['id'])
        render :layout => 'voucher_tab2'
      else
        render :nothing => true, :status => 400
      end
    end

    private
      def signup_params
        params[:user].permit(:phone)
      end
      def allow_iframe_requests
        response.headers.delete('X-Frame-Options')
      end
    end
  end
