class ApplicationController < ActionController::Base
  include AuthorizationHelper
  before_action :current_or_guest_user

  protect_from_forgery with: :exception
  protect_from_forgery except: :receive_guest
  protect_from_forgery with: :null_session, only: proc { |c| c.request.format.json? }
  before_action :detect_device_format
  before_action :configure_permitted_parameters, if: :devise_controller?

  protected

  def configure_permitted_parameters
    attributes = [:name]
    devise_parameter_sanitizer.permit(:sign_up, keys: attributes)
    devise_parameter_sanitizer.permit(:account_update, keys: attributes)
  end

  private

  def detect_device_format
    case request.user_agent
    when /iPad/i || /Android/i
      request.variant = :phone
    when /iPhone/i || /Windows Phone/i
      request.variant = :phone
    when /Android/i && /mobile/i
      request.variant = :phone
    end
  end
end
