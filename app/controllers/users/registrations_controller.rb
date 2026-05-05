class Users::RegistrationsController < Devise::RegistrationsController
  before_action :configure_sign_up_params, only: [:create]

  protected

  def configure_sign_up_params
    devise_parameter_sanitizer.permit(:sign_up, keys: [:name, :role, :bio, :hourly_rate, :profile_picture])
  end

  def build_resource(hash = {})
    super
    # Set default role to 'client' if not provided
    self.resource.role ||= :client
  end

  def after_sign_up_path_for(resource)
    # Redirect to the appropriate dashboard based on role
    resource.freelancer? ? freelancer_dashboard_path : client_dashboard_path
  end
end
