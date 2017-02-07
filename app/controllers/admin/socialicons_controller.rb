class Admin::SocialiconsController < AdminController
  before_action :set_socialicon, only: [:show, :edit, :update, :destroy]

  def index
    @socialicons = Socialicon.all.order(:id)
  end

  def edit
  end

  def update
    if @socialicon.update(socialicon_params)
      redirect_to :back, notice: 'ССЫЛКА УСТАНОВЛЕНА.'
    else
      render :edit
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_socialicon
      @socialicon = Socialicon.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def socialicon_params
      params.require(:socialicon).permit(:name, :iconlink)
    end
end
