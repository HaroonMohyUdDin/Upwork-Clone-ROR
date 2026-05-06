class ApplicationController < ActionController::Base
  before_action :configure_permitted_parameters, if: :devise_controller?

  allow_browser versions: :modern
  stale_when_importmap_changes

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: %i[name role bio hourly_rate profile_picture])
    devise_parameter_sanitizer.permit(:account_update, keys: %i[name role bio hourly_rate profile_picture])
  end

  def after_sign_in_path_for(resource)
    # FIX: Removed the typo "redirect_to"
    resource.freelancer? ? freelancer_dashboard_path : client_dashboard_path
  end

  def after_sign_up_path_for(resource)
    resource.freelancer? ? freelancer_dashboard_path : client_dashboard_path
  end

  def authorize_freelancer!
    redirect_to root_path, alert: 'Not authorized' unless current_user&.freelancer?
  end

  def authorize_client!
    redirect_to root_path, alert: 'Not authorized' unless current_user&.client?
  end
end