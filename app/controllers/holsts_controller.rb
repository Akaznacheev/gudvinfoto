class HolstsController < ApplicationController
  before_action :set_holst, only: %i[show edit update destroy]

  def index
    @holsts = current_or_guest_user.holsts.all.paginate(page: params[:page], per_page: 3)
    @price_list = PriceList.where(status: 'АКТИВЕН', kind: 'holst').first
    @holst = Holst.new
  end

  def show
    @order = Order.new
    @deliveries = Delivery.all
  end

  def new; end

  def edit
    @holst_price_list = PriceList.where(status: 'АКТИВЕН', kind: 'holst')
  end

  def create
    @holst = Holst.new(holst_params)
    if @holst.save
      redirect_to edit_holst_path(@holst), notice: 'Holst was successfully created.'
    else
      redirect_back(fallback_location: (request.referer || root_path))
    end
  end

  def update
    if params[:rotate]
      @holst.holst_image_rotate(@holst, params[:rotate].to_i)
      respond_to do |format|
        format.js { render inline: 'location.reload();' }
      end
    elsif params[:holst].present?
      @holst.update(price_list_id: PriceList.where(kind: 'holst', format: params[:holst][:price_list]).first.id) if params[:holst][:price_list]
      @holst.update(holst_params) if params[:holst][:price_list].blank?
      redirect_back(fallback_location: (request.referer || root_path))
    else
      @holst.update(positions: move[:positions]) if params[:dragged_image_params]
      redirect_back(fallback_location: (request.referer || root_path))
    end
  end

  def destroy
    @holst.destroy
    respond_to do |format|
      format.html { redirect_to holsts_url, notice: 'Holst was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private

  def set_holst
    @holst = current_or_guest_user.try(:admin?) ? Holst.find(params[:id]) : current_or_guest_user.holsts.find(params[:id])
  end

  def holst_params
    params.require(:holst).permit(:format, :rotate, :price, :user_id, :price_list, :price_list_id, :image)
  end

  def move
    params.require(:dragged_image_params).permit(:positions)
  end
end
