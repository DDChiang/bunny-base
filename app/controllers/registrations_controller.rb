class RegistrationsController < Devise::RegistrationsController 
  def create
    build_resource(registration_params)
    resource_saved = resource.save
    yield resource if block_given?
    if resource_saved
      if resource.active_for_authentication?
        set_flash_message :notice, :signed_up if is_flashing_format?
        sign_up(resource_name, resource)
        respond_with resource, location: after_sign_up_path_for(resource)
      else
        set_flash_message :notice, :"signed_up_but_#{resource.inactive_message}" if is_flashing_format?
        expire_data_after_sign_in!
        respond_with resource, location: after_inactive_sign_up_path_for(resource)
      end
    else
      clean_up_passwords resource
      @validatable = devise_mapping.validatable?
      if @validatable
        @minimum_password_length = resource_class.password_length.min
      end
      respond_with resource
    end
  end
  protected
  def after_sign_up_path_for(resource)
    edit_user_path(resource)
  end
  def after_inactive_sign_up_path_for(resource)
    edit_user_path(resource)
  end
  private
  def registration_params
    params.require(:user).permit(:email, :first_name, :last_name, :password, :password_confirmation)
  end
end

