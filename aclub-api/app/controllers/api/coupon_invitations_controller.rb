module Api
  class CouponInvitationsController < BaseController
    before_action :authenticate_user!

    def create
      if has_params?([:coupon_id], :coupon_invitation)
        coupon_invitation_service = CouponInvitationService.new(coupon_invitation_params, current_user)
        if coupon_invitation_service.create
          render json: coupon_invitation_service.response_data
        else
          render_errors(coupon_invitation_service.errors, :unprocessable_entity)
        end
      end
    end

    def update
      coupon_invitation_service = CouponInvitationService.new(invitation_response_params, current_user)
      if coupon_invitation_service.update
        render json: coupon_invitation_service.response_data
      else
        render_errors(coupon_invitation_service.errors, :unprocessable_entity)
      end
    end

    private
    def coupon_invitation_params
      params[:coupon_invitation].permit(:coupon_id, :inviter_id, invitee_ids: [])
    end

    def invitation_response_params
      params.permit(:id, :answer)
    end
  end
end
