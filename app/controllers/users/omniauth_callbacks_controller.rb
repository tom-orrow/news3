class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController
  def facebook
    authorize
  end

  def google_oauth2
    authorize
  end

  private

  def authorize
    @user = Service.find_for_oauth(request.env["omniauth.auth"])

    if @user.persisted?
      sign_in_and_redirect @user, event: :authentication
      set_flash_message(:notice, :success, kind: request.env["omniauth.auth"].provider.capitalize) if is_navigational_format?
    else
      set_flash_message(:error, :failure, kind: request.env["omniauth.auth"].provider.capitalize)
      redirect_to new_user_registration_url
    end
  end
end
