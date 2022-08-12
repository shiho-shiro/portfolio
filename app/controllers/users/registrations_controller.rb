class Users::RegistrationsController < Devise::RegistrationsController
  before_action :configure_account_update_params, only: [:update]
  before_action :check_guest, only: %i(update destroy)

  protected

  def configure_account_update_params
    devise_parameter_sanitizer.permit(:account_update, keys: [:username, :country_code, :job])
  end

  def after_update_path_for(resource)
    user_path(current_user.id)
  end

  def update_resource(resource, params)
    resource.update_without_current_password(params)
  end
end
