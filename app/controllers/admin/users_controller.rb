module Admin
  class UsersController < AdminController
    def index
      @users = User.where(guest: false).order('id DESC').paginate(page: params[:page], per_page: 10)
    end

    def update
      @user = User.find(params[:id])
      if @user.update_attributes(secure_params)
        redirect_back(fallback_location: (request.referer || root_path), notice: 'Права пользователя обновлены.')
      else
        redirect_back(fallback_location: (request.referer || root_path), alert: 'Ошибка.')
      end
    end

    def destroy
      user = User.find(params[:id])
      user.destroy
      redirect_back(fallback_location: (request.referer || root_path), notice: 'Пользователь удален.')
    end

    private

    def secure_params
      params.require(:user).permit(:role)
    end
  end
end
