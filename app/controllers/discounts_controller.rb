class DiscountsController < ApplicationController
  before_action :set_discount, only: [:show, :edit, :update, :destroy]

  def index
    @discounts = Discount.all
  end

  def show
  end

  def new
    @discount = Discount.new
  end

  def edit
  end

  def create
    @discount = Discount.new(discount_params)
      if @discount.save
        redirect_to @discount, notice: 'Discount was successfully created.'
      else
        render :new
      end
  end

  def update
      if @discount.update(discount_params)
        redirect_to @discount, notice: 'Discount was successfully updated.'
      else
        render :edit
      end
  end

  def destroy
    @discount.destroy
    respond_to do |format|
      format.html { redirect_to discounts_url, notice: 'Discount was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_discount
      @discount = Discount.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def discount_params
      params.require(:discount).permit(:name, :value)
    end
end
