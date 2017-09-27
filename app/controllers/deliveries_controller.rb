class DeliveriesController < ApplicationController
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
    if @delivery.save
      redirect_to :back, notice: 'ДОСТАВКА ' + @delivery.name + ' ДОБАВЛЕНА'
    else
      render :new
    end
  end

  def update
    if @delivery.update(delivery_params)
      redirect_to :back, notice: 'ДОСТАВКА ' + @delivery.name + ' ОБНОВЛЕНА.'
    else
      render :edit
    end
  end

  def destroy
    @delivery.destroy
    redirect_to :back, notice: 'ДОСТАВКА ' + @delivery.name + ' УДАЛЕНА.'
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_delivery
    @delivery = Delivery.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def delivery_params
    params.require(:delivery).permit(:name, :price)
  end
end
