class Admin < ActiveRecord::Base
  include PgSearch
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  pg_search_scope :search_by_eveything, against: [:name, :email, :phone]
  has_many :facebook_fanpages, dependent: :destroy
  has_many :restaurants, through: :facebook_fanpages
  has_many :coupons, through: :restaurants
  has_many :identities, as: :user, dependent: :destroy
  has_many :advertising_events, dependent: :destroy, foreign_key: 'user_id'
  has_many :menus, as: :owner
  ROLES = [ADMIN = 'admin', OWNER = 'owner']
  scope :owners, -> { where(role: OWNER) }

  def admin?
    role == ADMIN
  end

  def owner?
    role == OWNER
  end

  def self.search(query=nil)
    query.present? ? search_by_eveything(query) : all
  end

  def update_owner(params)
    update_attributes(params)
  end

  def default_identity_id
    identities.first.try(:id)
  end

  def default_fanpage
    facebook_fanpages.first
  end
end
