class BookpricesController < ApplicationController
  before_action :set_bookprice, only: [:show, :edit, :update, :destroy]

  # GET /bookprices
  # GET /bookprices.json
  def index
    @bookprices = Bookprice.all
  end

  # GET /bookprices/1
  # GET /bookprices/1.json
  def show
  end

  # GET /bookprices/new
  def new
    @bookprice = Bookprice.new
  end

  # GET /bookprices/1/edit
  def edit
  end

  # POST /bookprices
  # POST /bookprices.json
  def create
    @bookprice = Bookprice.new(bookprice_params)

    respond_to do |format|
      if @bookprice.save
        format.html { redirect_to @bookprice, notice: 'Bookprice was successfully created.' }
        format.json { render :show, status: :created, location: @bookprice }
      else
        format.html { render :new }
        format.json { render json: @bookprice.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /bookprices/1
  # PATCH/PUT /bookprices/1.json
  def update
    respond_to do |format|
      if @bookprice.update(bookprice_params)
        format.html { redirect_to @bookprice, notice: 'Bookprice was successfully updated.' }
        format.json { render :show, status: :ok, location: @bookprice }
      else
        format.html { render :edit }
        format.json { render json: @bookprice.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /bookprices/1
  # DELETE /bookprices/1.json
  def destroy
    @bookprice.destroy
    respond_to do |format|
      format.html { redirect_to bookprices_url, notice: 'Bookprice was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_bookprice
      @bookprice = Bookprice.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def bookprice_params
      params.require(:bookprice).permit(:format, :cover, :page)
    end
end
