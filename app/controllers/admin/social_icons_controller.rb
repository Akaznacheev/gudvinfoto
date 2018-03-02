module Admin
  class SocialIconsController < AdminController
    before_action :set_social_icon, only: %i[show edit update destroy]

    def index
      @social_icons = SocialIcon.all.order(:id)
    end

    def edit; end

    def update
      if @social_icon.update(social_icon_params)
        redirect_back(fallback_location: (request.referer || root_path),
                      notice: "ССЫЛКА #{@social_icon.name} УСТАНОВЛЕНА.")
      else
        render :edit
      end
    end

    private

    def set_social_icon
      @social_icon = SocialIcon.find(params[:id])
    end

    def social_icon_params
      params.require(:social_icon).permit(:name, :icon_link)
    end
  end
end
