class SessionsController < Devise::SessionsController
  before_filter :set_header_background_color, only: [:new]
end
