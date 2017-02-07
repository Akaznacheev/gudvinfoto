class AdminController < ApplicationController
  before_filter :user_admin?

  layout 'admin'

  private
  def user_admin?
    unless current_user.present? && current_user.admin?
      flash[:error] = "У вас нет доступа к этой странице."
      redirect_to root_path
    end
  end
end