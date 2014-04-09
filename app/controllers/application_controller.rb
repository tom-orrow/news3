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
    @categories_list ||= Category.where(parent_id: nil)
  end
rescue_from CanCan::AccessDenied do |exception|
  Rails.logger.debug "Access denied on #{exception.action} #{exception.subject.inspect}"
end
end
