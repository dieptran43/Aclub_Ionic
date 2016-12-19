class AdvertisingEvent < ActiveRecord::Base
  extend FriendlyId
  friendly_id :url, use: :slugged
  
  mount_uploader :home_page_background, ImageUploader
  mount_uploader :win_page_background, ImageUploader

  has_many :user_advertising_events, dependent: :destroy
  has_many :users, through: :user_advertising_events
  belongs_to :admin, foreign_key: 'user_id'
  scope :current, -> { where('advertising_events.end_at > ?', Date.current) }

  validates_uniqueness_of :url

  def public_link(domain)
    slug.nil? ? "" : "http://#{domain}/advertising_events/#{slug}"
  end

  def self.get_by_owner_fanpage_id(page_id)
    @owner = Admin.joins('join identities on admins.id = identities.user_id').where('identities.uid = ? and admins.role = ?', page_id, 'owner')[0]
    @vouchers = AdvertisingEvent.where('user_id = ? and enabled = ? and end_at> ?',@owner.id, true, Date.current).order('begin_at DESC')
  end
end
