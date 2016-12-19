class RegistrationsController < Devise::RegistrationsController
  before_filter :set_header_background_color, only: [:new]
end
