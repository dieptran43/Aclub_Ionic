module Api
  class CouponInvitationService
    attr_accessor :coupon_invitation_params, :user, :errors

    def initialize(coupon_invitation_params, user)
      self.coupon_invitation_params = coupon_invitation_params
      self.user = user
    end

    def create
      if Coupon.exists?(id: coupon_invitation_params[:coupon_id])
        coupon_invitation_params[:invitee_ids].each do |invitee_id|
          if User.exists?(id: invitee_id)
            user.coupon_invitation_invitees.find_or_create_by(invitee_id: invitee_id, coupon_id: coupon_invitation_params[:coupon_id])
          end
        end
      else
        self.errors = I18n.t('base.api.not_found')
      end

      errors.blank?
    end

    def update
      coupon_invitation = CouponInvitation.find_by(id: coupon_invitation_params[:id])
      if coupon_invitation.try(:invitee_id) == user.id && CouponInvitation::ACTIONS.include?(coupon_invitation_params[:answer])
        coupon_invitation.update_attributes(status: coupon_invitation_params[:answer])
      else
        self.errors = I18n.t('base.api.not_found')
      end

      errors.blank?
    end

    def response_data
      ArrayPresenter.new(user.coupon_invitation_invitees.where(coupon_id: coupon_invitation_params[:coupon_id]).includes(:invitee, :coupon), CouponInvitationPresenter)
    end
  end
end
