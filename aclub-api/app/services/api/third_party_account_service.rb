module Api
  class ThirdPartyAccountService
    attr_accessor :params, :user, :device_token, :phone, :errors, :identity, :user_agent

    def initialize(params)
      self.params = params
      self.device_token = params.delete(:device_token)
      self.phone = params.delete(:phone)
      self.phone = Api::PhoneParser.normalize(phone) if phone.present?
      self.user_agent = params.delete(:user_agent)
    end

    def create
      self.user = initialize_user
      if user.present?
        if user.save
          user.add_device_token(device_token, user_agent)
        else
          self.errors = user.errors.full_messages.join('. ')
        end
      else
        self.errors = I18n.t("base.api.third_party.missing_parametters") if errors.blank?
      end
      errors.blank?
    end

    def response_data
      AuthorizedUserPresenter.new(user)
    end

    private

    def initialize_user
      self.identity = Identity.initialize_with_parameters(params)
      if identity.present?
        initialize_user_entity
      end
    end

    def initialize_user_entity
      user_data = identity.fetch_data
      if user_data.present?
        if identity.user.present?
          if phone.present? && phone != identity.user.phone
            self.errors = I18n.t("base.api.third_party.linked_with_other_user") and return
          else
            identity.user
          end
        else
          user = User.find_by(phone: phone) || User.find_by(email: user_data[:email]) || User.new
          profile_picture = user_data.delete(:profile_picture)
          user.assign_attributes(user_data.merge(phone: phone))
          user.remote_avatar_url = profile_picture
          user.identities << identity
          user
        end
      else
        self.errors = identity.errors.full_messages.join('. ') and return
      end
    end
  end
end
