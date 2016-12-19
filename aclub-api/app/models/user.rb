class User < ActiveRecord::Base
  include PgSearch
  include Commenter

  devise :database_authenticatable, :recoverable, :validatable
  pg_search_scope :search_by_eveything, against: [:name, :email, :phone]

  commenter
  acts_as_follower
  acts_as_followable

  has_one :authentication_token, dependent: :destroy
  has_many :identities, as: :user, dependent: :destroy
  has_many :reviews, dependent: :destroy
  has_many :user_coupons, dependent: :destroy
  has_many :user_vouchers, dependent: :destroy
  has_many :coupon_invitation_inviters, foreign_key: 'invitee_id', class_name: CouponInvitation, dependent: :destroy
  has_many :coupon_invitation_invitees, foreign_key: 'inviter_id', class_name: CouponInvitation, dependent: :destroy
  has_many :coupons, through: :user_coupons, source: :coupon
  has_many :available_coupons, -> {
    where user_coupons: { status: 0 }
  }, through: :user_coupons, source: :coupon
  has_many :used_coupons, -> {
    where user_coupons: { status: 1 }
  }, through: :user_coupons, source: :coupon
  has_many :following_users, through: :follows, source: :followable, source_type: User.to_s
  has_many :devices, dependent: :destroy
  has_many :user_advertising_events, dependent: :destroy
  has_many :advertising_events, through: :user_advertising_events

  PHONE_REGEX = /\A84(9|1)[0-9]{8,9}\z/
  validates :phone, presence: true, format: { with: /\A84(9|1)[0-9]{8,9}\z/,
                                              message: I18n.t('activerecord.errors.models.user.attributes.phone.invalid') }
  validates :phone, uniqueness: true
  validates :email, uniqueness: true, allow_blank: true
  validates :name, presence: true, if: :required_name?
  validate :unregistered_email
  validate :not_allow_to_update_phone, on: :update

  before_validation :normalize_phone
  before_create :set_tokens
  #after_create :send_verification_code

  delegate :urls, to: :avatar, prefix: true
  mount_uploader :avatar, ImageUploader
  

  scope :newest, -> { order('created_at DESC') }
  scope :most_active, -> { newest }
  
  def self.find_by_fb(email, token) #token la fb id
    where('users.email = ? or users.facebook_token = ?' ,email, token)
  end
  
  def avatar1
    @str = "#{avatar}"
    # json: { origin: @str, thumb: @str }
    return { origin: @str , thumb: @str}   
  end

  def generate_phone_verification_token
    self.verification_token = loop do
      random_token = (100000 + Random.rand(899999)).to_s
      break random_token unless User.exists?(verification_token: random_token)
    end
  end

  def generate_email_verification_token
    self.email_verification_token = loop do
      random_token = (100000 + Random.rand(899999)).to_s
      break random_token unless User.exists?(email_verification_token: random_token)
    end
  end

  def invitees(coupon_id)
    User.where(id: coupon_invitation_invitees.where(coupon_id: coupon_id).pluck(:invitee_id))
  end

  def pending_invitees(coupon)
    User.where(id: coupon_invitation_invitees.where(coupon: coupon).pending.pluck(:invitee_id))
  end

  def accepted_invitees(coupon)
    User.where(id: coupon_invitation_invitees.where(coupon: coupon).accepted.pluck(:invitee_id))
  end

  def denied_invitees(coupon)
    User.where(id: coupon_invitation_invitees.where(coupon: coupon).denied.pluck(:invitee_id))
  end

  def add_device_token(device_token, user_agent=nil)
    if device_token.present?
      device = Device.find_by(token: device_token)
      if device.present?
        if device.user != self
          device.destroy
          self.devices.create!(token: device_token, user_agent: user_agent)
        end
      else
        self.devices.create!(token: device_token, user_agent: user_agent)
      end
    end
  end

  def invite(invitee, coupon)
    CouponInvitation.find_or_create_by(inviter_id: id, invitee_id: invitee.id, coupon_id: coupon.id)
  end

  def representative_name
    name.present? ? name : phone
  end

  def send_verification_code
    PhoneVerificationJob.perform_later(self)
  end

  def number_of_accepted_invitees(coupon)
    accepted_invitees(coupon).count
  end

  def can_receive_coupon?(coupon)
    number_of_accepted_invitees(coupon) >= coupon.required_minimum_invitees
  end

  def humanized_phone
    "+#{phone[0..1]} #{phone[2..3]} #{phone[4..6]} #{phone[7..-1]}" if phone
  end

  def is_winner?(advertising_event)
    user_advertising_events.where(advertising_event: advertising_event).first.try(:won?)
  end

  def joined?(advertising_event)
    user_advertising_events.where(advertising_event: advertising_event).first.present?
  end

  def lucky_code(advertising_event)
    user_advertising_events.where(advertising_event: advertising_event).first.try(:lucky_code)
  end

  def used_user_coupons
    user_coupons.used
  end

  def available_user_coupons
    user_coupons.available
  end

  private
  def normalize_phone
    old_phone = phone
    begin
      self.phone = Api::PhoneParser.normalize(old_phone)
    rescue
      #rescue to avoid case phone = nil which throw exception no gsub for nil class
    end
  end

  def set_tokens
    self.authentication_token = AuthenticationToken.new
    generate_phone_verification_token
  end

  def email_required?
    false
  end

  def password_required?
    false
  end

  def required_name?
    persisted? && name_changed?
  end

  def unregistered_email
    if unverified_email && User.find_by_email(unverified_email)
      errors.add(:email, I18n.t("activerecord.errors.models.user.attributes.email.taken"))
    end
  end

  def not_allow_to_update_phone
    old_phone = User.find_by_id(id).try(:phone)
    if old_phone.present? && phone_changed?
      errors.add(:phone, I18n.t("activerecord.errors.models.user.attributes.phone.cannot_change"))
    end
  end

  def self.search(query=nil)
    query.present? ? search_by_eveything(query) : all
  end
end
