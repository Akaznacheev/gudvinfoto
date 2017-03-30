class UsersController < ApplicationController
  before_action :authenticate_user!
  after_action :verify_authorized

  def index
    @users = User.all
    authorize User
  end

  def new
    @user = User.new
  end

  def show
    @user = User.find(params[:id])
    authorize @user
  end

  def update
    @user = User.find(params[:id])
    authorize @user
    if @user.update_attributes(secure_params)
      redirect_to :back, :notice => "Права пользователя обновлены."
    else
      redirect_to :back, :alert => "Ошибка."
    end
  end

  def destroy
    user = User.find(params[:id])
    authorize user
    user.destroy
    redirect_to :back, :notice => "Пользователь удален."
  end

  private

  def secure_params
    params.require(:user).permit(:role)
  end

  def user_params
    params.require(:user).permit(:username, :email, :password, :password_confirmation, :remember_me, :name, :nickname, :uid, :provider, :city, :url, :role,)
  end
  before_action :configure_permitted_parameters, if: :devise_controller?
  protected
  def configure_permitted_parameters
    devise_parameter_sanitizer.for(:account_update) { |u| u.permit(:password, :password_confirmation,:current_password,:email,:name, :phonenumber,:province,:city,:area,:idcardimg,:role) }
    devise_parameter_sanitizer.for(:sign_up) { |u| u.permit(:password, :password_confirmation,:current_password,:email,:name, :phonenumber,:province,:city,:area,:idcardimg,:role) }
  end
end
