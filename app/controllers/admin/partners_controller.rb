module Admin
  class PartnersController < AdminController
    before_action :set_partner, only: %i[show edit update destroy]

    def index
      @partners = Partner.all
    end

    def show; end

    def new
      @partner = Partner.new
    end

    def edit; end

    def create
      @partner = Partner.new(partner_params)

      respond_to do |format|
        if @partner.save
          format.html { redirect_to admin_partners_path, notice: 'Партнер добавлен.' }
          format.json { render :show, status: :created, location: @partner }
        else
          format.html { render :new }
          format.json { render json: @partner.errors, status: :unprocessable_entity }
        end
      end
    end

    def update
      respond_to do |format|
        if @partner.update(partner_params)
          format.html { redirect_to admin_partners_path, notice: 'Вы успешно добавили нового партнера.' }
          format.json { render :show, status: :ok, location: @partner }
        else
          format.html { render :edit }
          format.json { render json: @partner.errors, status: :unprocessable_entity }
        end
      end
    end

    def destroy
      @partner.destroy
      respond_to do |format|
        format.html { redirect_to admin_partners_url, notice: 'Партнер был удален.' }
        format.json { head :no_content }
      end
    end

    private

    def set_partner
      @partner = Partner.find(params[:id])
    end

    def partner_params
      params.require(:partner).permit(:name, :description, :link, :attachment)
    end
  end
end
