class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception


  before_action :authorize_user!

  rescue_from Permitter::Unauthorized do |exception|
    redirect_to projects_url, alert: exception.message
  end

  private

  def current_permissions
    @current_permissions ||= Permission.new(current_user)
  end

end
