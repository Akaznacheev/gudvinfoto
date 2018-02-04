module Admin
  class SocialiconsController < AdminController
    before_action :set_socialicon, only: %i[show edit update destroy]

    def index
      @socialicons = Socialicon.all.order(:id)
    end

    def edit; end

    def update
      if @socialicon.update(socialicon_params)
        redirect_back(fallback_location: (request.referer || root_path), notice: "ССЫЛКА #{@socialicon.name} УСТАНОВЛЕНА.")
      else
        render :edit
      end
    end

    private

    def set_socialicon
      @socialicon = Socialicon.find(params[:id])
    end

    def socialicon_params
      params.require(:socialicon).permit(:name, :iconlink)
    end
  end
end
