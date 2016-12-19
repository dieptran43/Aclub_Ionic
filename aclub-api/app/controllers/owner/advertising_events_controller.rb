module Owner
  class AdvertisingEventsController < BaseController
    def index
      @advertising_events = AdvertisingEvent.where('user_id = ?', current_admin.id).order('updated_at DESC').page(params[:page])
    end

    def new
      @page_title = t('owner.advertising_events.title')
      @advertising_event = AdvertisingEvent.new
    end

    def create
      advertising_event_params[:user_id] = current_admin.id
      if advertising_event = AdvertisingEvent.create(advertising_event_params)
        redirect_to owner_advertising_event_path(advertising_event)
      end
    end

    def show
      @advertising_event = AdvertisingEvent.friendly.find(params[:id])
      @users = @advertising_event.users
    end

    def destroy
      if advertising_event = AdvertisingEvent.find_by_id(params[:id])
        advertising_event.destroy
        redirect_to owner_advertising_events_path
      end
    end

    def edit
      @advertising_event = AdvertisingEvent.find_by_id(params[:id])
    end

    def update
      if advertising_event = AdvertisingEvent.friendly.find(params[:id])
        advertising_event.update_attributes(advertising_event_params)
        redirect_to owner_advertising_event_path(advertising_event.id)
      end
    end

    private
    def advertising_event_params
      params.require(:advertising_event).permit(
          :description, :url, :name,
          :home_page_background, :win_page_background, :winning_rate,
          :maximum_number_of_winners, :end_at, :begin_at, :enabled,
          :reference_link_1, :reference_link_2, :user_id
      )
    end
  end
end
