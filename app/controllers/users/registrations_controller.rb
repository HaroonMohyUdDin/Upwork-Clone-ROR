class Users::RegistrationsController < Devise::RegistrationsController
  before_action :configure_sign_up_params, only: [:create]

  protected

  def configure_sign_up_params
    devise_parameter_sanitizer.permit(:sign_up, keys: [:name, :role, :bio, :hourly_rate, :profile_picture])
  end

  def build_resource(hash = {})
    super
    # Ensure role is set
    if self.resource.role.blank?
      self.resource.role = 'client'
    end
  end

  def after_sign_up_path_for(resource)
    resource.freelancer? ? freelancer_dashboard_path : client_dashboard_path
  end
end