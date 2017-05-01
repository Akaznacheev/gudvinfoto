class BookpricesController < ApplicationController
  before_action :set_bookprice, only: %i(show edit update destroy)

  def index
    @bookprices = Bookprice.all
  end

  def show; end

  def new
    @bookprice = Bookprice.new
  end

  def edit; end

  def create
    @bookprice = Bookprice.new(bookprice_params)
    if params[:default] == 'ПО УМОЛЧАНИЮ'
      @bookprices = Bookprice.all
      @bookprices.each do |price|
        price.update(default: 'НЕТ')
      end
      @bookprice.update(default: params[:default])
    end
    @bookprice.update(status: params[:status]) if params[:status].present?
    if Bookprice.all.count < 2
      @bookprice.update(default: 'ПО УМОЛЧАНИЮ', status: 'АКТИВЕН')
    end
    respond_to do |format|
      if @bookprice.save
        format.html { redirect_to :back, notice: 'ФОРМАТ ДОБАВЛЕН.' }
        format.json { render :show, status: :created, location: @bookprice }
      else
        format.html { render :new }
        format.json { render json: @bookprice.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    if params[:default] == 'ПО УМОЛЧАНИЮ'
      @bookprices = Bookprice.all
      @bookprices.each do |price|
        price.update(default: 'НЕТ')
      end
      @bookprice.update(default: params[:default])
    end
    @bookprice.update(status: params[:status]) if params[:status].present?
    respond_to do |format|
      if @bookprice.update(bookprice_params)
        format.html { redirect_to :back, notice: 'CТОИМОСТЬ' + @bookprice.format + 'ОБНОВЛЕНА.' }
        format.json { render :show, status: :ok, location: @bookprice }
      else
        format.html { render :edit }
        format.json { render json: @bookprice.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @bookprice.destroy
    respond_to do |format|
      format.html { redirect_to :back, notice: 'ФОРМАТ УДАЛЕН.' }
      format.json { head :no_content }
    end
  end

  private

  def set_bookprice
    @bookprice = Bookprice.find(params[:id])
  end

  def bookprice_params
    params.require(:bookprice).permit(:format, :status, :default, :defaultpagescount, :coverprice, :twopageprice,
                                      :coverwidth, :coverheight, :twopagewidth, :twopageheight)
  end
end
