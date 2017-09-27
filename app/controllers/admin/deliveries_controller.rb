module Admin
  class DeliveriesController < AdminController
    before_action :set_delivery, only: %i[show edit update destroy]

    def index
      @deliveries = Delivery.all
    end

    def show; end

    def new
      @delivery = Delivery.new
    end

    def edit; end

    def create
      @delivery = Delivery.new(delivery_params)

      respond_to do |format|
        if @delivery.save
          format.html { redirect_to :back, notice: 'ДОСТАВКА ' + @delivery.name + ' ДОБАВЛЕНА' }
          format.json { render :show, status: :created, location: @delivery }
        else
          format.html { render :new }
          format.json { render json: @delivery.errors, status: :unprocessable_entity }
        end
      end
    end

    def update
      respond_to do |format|
        if @delivery.update(delivery_params)
          format.html { redirect_to :back, notice: 'ДОСТАВКА ' + @delivery.name + ' ОБНОВЛЕНА.' }
          format.json { render :show, status: :ok, location: @delivery }
        else
          format.html { render :edit }
          format.json { render json: @delivery.errors, status: :unprocessable_entity }
        end
      end
    end

    def destroy
      @delivery.destroy
      respond_to do |format|
        format.html { redirect_to :back, notice: 'ДОСТАВКА ' + @delivery.name + ' УДАЛЕНА.' }
        format.json { head :no_content }
      end
    end

    private

    def set_delivery
      @delivery = Delivery.find(params[:id])
    end

    def delivery_params
      params.require(:delivery).permit(:name, :price)
    end
  end
end
