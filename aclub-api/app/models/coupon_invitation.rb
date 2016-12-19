class CouponInvitation < ActiveRecord::Base
  belongs_to :inviter, foreign_key: 'inviter_id', class_name: User
  belongs_to :invitee, foreign_key: 'invitee_id', class_name: User
  belongs_to :coupon
  acts_as_mappable through: :coupon

  validates_uniqueness_of :coupon_id, scope: [:invitee_id, :invitee_id]

  enum status: { pending: 0, accepted: 1, denied: 2 }

  ACTIONS = [
    ACCEPT = 'accepted',
    DENY = 'denied'
  ]

  after_commit :send_push_notification, on: :create
  after_update :send_invitation_response_notification, if: :status_changed?

  scope :pending, -> {
    where('coupon_invitations.status = ?', 0)
  }
  
  def self.get_notification_coupon_invite(invitee_id)
    pending.joins(:coupon, :inviter).where('coupon_invitations.invitee_id=' + invitee_id)
  end
  
  def coupon_name
    coupon.try(:short_description)
  end
  

  private

  def send_invitation_response_notification
    InvitationResponseJob.perform_later(id)
  end

  def send_push_notification
    InvitationJob.perform_later(id)
  end
end
