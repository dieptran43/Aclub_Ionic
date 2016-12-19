module Facebook
  class FacebookVoucherService
    attr_accessor :voucher_params

    def initialize(voucher_params)
      self.voucher_params = voucher_params
    end

    def check_number()
      normalized_phone = Api::PhoneParser.normalize(voucher_params[:user][:phone])
      if (user_object = User.find_by_phone(normalized_phone))
        if(voucher_params[:user][:verification_code].blank?) #user do not send verification code
          user_voucher = UserAdvertisingEvent.find_or_create_by(user_id: user_object.id, advertising_event_id: voucher_params[:user][:coupon_id])
          return {:status => 1, :user => normalized_phone, :voucher => {:code => user_voucher.lucky_code, :status => user_voucher.won?}}
        else
          if( user_object.verification_token.casecmp(voucher_params[:user][:verification_code]) == 0)
            user_voucher = UserAdvertisingEvent.find_or_create_by(user_id: user_object.id, advertising_event_id: voucher_params[:user][:coupon_id])
            return {:status => 1, :user => normalized_phone, :voucher => {:code => user_voucher.lucky_code, :status => user_voucher.won?}}
          else
            return {:errors => "Mã xác nhận không đúng, vui lòng nhập lại"}, status: :unprocessable_entity
          end
        end
      else
        registration_service = Api::RegistrationService.new(signup_params)
        if registration_service.create
          return {:status => 0, :data => registration_service.response_data}
        else
          return registration_service.errors, status: :unprocessable_entity
        end
      end
    end

    def self.decode_facebook_hash(signed_request)
      signature, encoded_hash = signed_request.split('.')
      begin
        ActiveSupport::JSON.decode(Base64.decode64(encoded_hash))
      rescue ActiveSupport::JSON::ParseError
        ActiveSupport::JSON.decode(Base64.decode64(encoded_hash) + "}")
      end
    end

    private
    def signup_params
      return {:phone => voucher_params[:user][:phone]}
      # voucher_params[:user].permit(:phone)
    end
  end
end