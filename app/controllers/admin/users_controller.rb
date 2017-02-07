class Admin::UsersController < AdminController
  def index
    @users = User.all.order(:id).paginate(:page => params[:page], :per_page => 12)
  end

  def update
    @user = User.find(params[:id])
    if @user.update_attributes(secure_params)
      redirect_to :back, :notice => "Права пользователя обновлены."
    else
      redirect_to :back, :alert => "Ошибка."
    end
  end

  def destroy
    user = User.find(params[:id])
    user.destroy
    redirect_to :back, :notice => "Пользователь удален."
  end

  private

  def secure_params
    params.require(:user).permit(:role)
  end
end
