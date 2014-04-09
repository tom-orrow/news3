class ConfirmationsController < Devise::ConfirmationsController
  def show
    self.resource = resource_class.confirm_by_token(params[:confirmation_token])

    if resource.errors.empty?
      set_flash_message(:notice, :confirmed)
      respond_with_navigational(resource) { redirect_to after_confirmation_path_for(resource_name, resource) }
    else
      set_flash_message(:alert, :invalid_token)
      respond_with_navigational(resource.errors, status: :unprocessable_entity) {
        redirect_to after_confirmation_path_for(resource_name, resource)
      }
    end
  end

  protected

  def after_confirmation_path_for(resource_name, resource)
    root_path
  end

end
