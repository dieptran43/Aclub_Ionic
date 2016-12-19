module Cms
  class PartnersController < BaseController
    def index
      @partners = Partner.order('updated_at DESC').page(params[:page])
    end

    def new
      @page_title = t('cms.partners.title')
      @partner = Partner.new
    end

    def create
      if partner = Partner.create(partner_params)
        redirect_to cms_partner_path(partner)
      end
    end

    def show
      @partner = Partner.find_by_id(params[:id])
    end

    def edit
      @partner = Partner.find_by_id(params[:id])
    end

    def update
      if partner = Partner.find_by_id(params[:id])
        partner.update_attributes(partner_params)
        redirect_to cms_partner_path(partner)
      end
    end

    def destroy
      if partner = Partner.find_by_id(params[:id])
        partner.destroy
        redirect_to cms_partners_path
      end
    end

    private
    def partner_params
      params.require(:partner).permit(:name, :url, :image, :active, :order)
    end

  end
end