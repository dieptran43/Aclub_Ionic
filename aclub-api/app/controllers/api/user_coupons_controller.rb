module Api
  class UserCouponsController < BaseController
    before_action :authenticate_user!
    before_action :require_coupon! , only: [:create,:update]
    
    def show
      @ucp = UserCoupon.find_by_id(params[:id])
      render json: @ucp
    end
    
    def get_user_coupon
      render json: UserCoupon.find_by_userid_couponid(params[:user_id], params[:coupon_id])
    end
    
    def create
      if @coupon.has_more_quantity?
        if current_user.can_receive_coupon?(@coupon)
          current_user.user_coupons.find_or_create_by(coupon_id: user_coupon_params[:coupon_id])
          head :ok
        else
          render_errors(I18n.t('base.api.user_coupons.not_enough_accepted_invitation'), :unprocessable_entity)
        end
      else
        render_errors(I18n.t('base.api.user_coupons.no_more_quantity'), :unprocessable_entity)
      end
    end

    def update
      if user_coupon = current_user.user_coupons.find_by(coupon_id: @coupon.id)
        user_coupon.used!
        impressionist(user_coupon.coupon, Coupon::USED)
        head :ok
      else
        render_errors(I18n.t('base.api.user_coupons.not_found'), :not_found)
      end
    end

    private

    def require_coupon!
      if has_params?([:coupon_id], :user_coupon)
        @coupon = Coupon.find_by(id: user_coupon_params[:coupon_id])
        render_errors(I18n.t('base.api.not_found'), :not_found) unless @coupon
      end
    end

    def user_coupon_params
      params[:user_coupon].permit(:coupon_id)
    end
  end
end
