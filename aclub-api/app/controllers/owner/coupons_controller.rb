module Owner
  class CouponsController < BaseController

    def code_form
    end

    def redeem_code
      begin
        coupon = Coupon.find_by(id: params[:coupon_id])
        user_coupon = coupon.user_coupons.find_by(token: params[:code])
        user = user_coupon.user
        if user_coupon.available?
          user_coupon.used!
          render json: { message: "Successfully used coupon for user #{user.representative_name}" }
        else
          render json: { message: "User #{user.representative_name} already used the coupon" }
        end
      rescue
        render json: { message: 'Error happening. Please try it again' }
      end
    end

    private
    def coupon_params
      params.require(:coupon).permit(:quantity)
    end
  end
end
