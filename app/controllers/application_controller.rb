class ApplicationController < ActionController::Base
  before_filter do
    @categories_list ||= Category.where(parent_id: nil)

    # Workaround for Cancan and strong parameters
    resource = controller_name.singularize.to_sym
    method = "#{resource}_params"
    params[resource] &&= send(method) if respond_to?(method, true)
  end

  rescue_from CanCan::AccessDenied do |exception|
    Rails.logger.debug "Access denied on #{exception.action} #{exception.subject.inspect}"
  end
end
