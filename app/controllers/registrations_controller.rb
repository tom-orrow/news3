class RegistrationsController < Devise::RegistrationsController
  def create
    build_resource(user_params)
    if resource.save
      expire_session_data_after_sign_in!
      return render json: { success: true, notice: [t('devise.registrations.signed_up_but_unconfirmed')] }
    else
      clean_up_passwords resource
      return render json: { success: false, errors: resource.errors.full_messages }
    end
  end

  def sign_up(resource_name, resource)
    sign_in(resource_name, resource)
  end

  def user_params
    params.require(:user).permit(:email, :password, :password_confirmation)
  end

end
