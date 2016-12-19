class Identity < ActiveRecord::Base
  belongs_to :user, polymorphic: true

  validates :uid, uniqueness: true
  validates :uid, presence: true

  def self.initialize_with_parameters(parameters)
    if sufficient_identity_info?(parameters)
      case parameters[:provider]
        when ThirdPartyAccountProvider::Facebook
          FacebookIdentity.find_for_auth(parameters)
      end
    end
  end

  def fetch_data
    raise NotImplementedError.new("This method is not designed to use directly. You must implement this method in the subclasses")
  end

  protected

  def self.find_for_auth(auth)
    identity = find_or_initialize_by(uid: auth[:uid])
    identity.access_token = auth[:access_token] if auth[:access_token].present?
    identity.access_token_secret = auth[:access_token_secret] if auth[:access_token_secret].present?
    identity.save if identity.persisted?
    identity
  end

  def self.sufficient_identity_info?(parameters)
    parameters[:uid].present? && parameters[:provider].present?
  end
end
