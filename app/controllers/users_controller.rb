class UsersController < ApplicationController
  before_action :authenticate_user!
  after_action :verify_authorized

  def index
    @users = User.all
    authorize User
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

end
