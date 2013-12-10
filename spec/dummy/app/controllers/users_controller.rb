class UsersController < ApplicationController
  before_action :current_resource, only: :show

  def index
    @users = User.permitted_by(current_permissions)
  end

  def show
  end

  private

  def current_resource
    @user ||= User.find(params[:id]) if params[:id]
  end

end
