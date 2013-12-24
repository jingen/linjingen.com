class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  before_filter :store_location
  after_filter :set_csrf_cookie

  def set_csrf_cookie
    cookies['XSRF-TOKEN'] = form_authenticity_token if protect_against_forgery?
  end

  def store_location
    logger.debug request.original_url
    logger.debug params
    if should_store_url?
      session[:user_return_to] = request.original_url
    end
  end

  def stored_location_for(resource_or_scope)
    session[:user_return_to] || super
  end

  def after_sign_in_path_for(resource)
    stored_location_for(resource) || root_path
  end

  protected

  def verified_request?
    super || form_authenticity_token == request.headers['X-XSRF-TOKEN']
  end

  def should_store_url?
    controller = params[:controller]
    action     = params[:action]
    controller == "welcome" || (action == "index" && (controller == "documents" || controller == "video" || controller == "words" || controller == "images"))
  end
end
