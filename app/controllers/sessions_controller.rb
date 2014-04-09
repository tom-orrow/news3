class SessionsController < Devise::SessionsController

  def create
    @user = User.where(:email => params[:user][:email])[0]
    if !@user || @user.confirmed?
      resource = warden.authenticate!(:scope => resource_name, :recall => "#{controller_path}#failure")
      return sign_in_and_redirect(resource_name, resource)
    else
      render :json => {:success => false, :errors => [t("devise.failure.unconfirmed")]}
    end
  end

  def sign_in_and_redirect(resource_or_scope, *args)
    options  = args.extract_options!
    scope    = Devise::Mapping.find_scope!(resource_or_scope)
    resource = args.last || resource_or_scope
    sign_in(scope, resource, options)
    return render :json => {:success => true, :redirect => stored_location_for(scope) || after_sign_in_path_for(resource)}
  end

  def failure
    return render :json => {:success => false, :errors => ["Login failed."]}
  end
end
