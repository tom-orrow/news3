class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  # Workaround for Cancan and strong parameters
  before_filter do
    resource = controller_name.singularize.to_sym
    method = "#{resource}_params"
    params[resource] &&= send(method) if respond_to?(method, true)
  end

  before_filter do
    @categories ||= Category.all
    @current_category = params['category_id'] ? params['category_id'].to_i : nil
  end
end
