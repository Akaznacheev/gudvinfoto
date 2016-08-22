class BookpagesController < ApplicationController
  before_action :set_bookpage, only: [:show, :edit, :update, :destroy]

  # GET /bookpages
  # GET /bookpages.json
  def index
    @bookpages = Bookpage.all
  end

  # GET /bookpages/1
  # GET /bookpages/1.json
  def show
  end

  # GET /bookpages/new
  def new
    @bookpage = Bookpage.new
  end

  # GET /bookpages/1/edit
  def edit
  end

  # POST /bookpages
  # POST /bookpages.json
  def create
    @bookpage = Bookpage.new(bookpage_params)

    respond_to do |format|
      if @bookpage.save
        format.html { redirect_to @bookpage, notice: 'Bookpage was successfully created.' }
        format.json { render :show, status: :created, location: @bookpage }
      else
        format.html { render :new }
        format.json { render json: @bookpage.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /bookpages/1
  # PATCH/PUT /bookpages/1.json
  def update
    respond_to do |format|
      if @bookpage.update(bookpage_params)
        format.html { redirect_to @bookpage, notice: 'Bookpage was successfully updated.' }
        format.json { render :show, status: :ok, location: @bookpage }
      else
        format.html { render :edit }
        format.json { render json: @bookpage.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /bookpages/1
  # DELETE /bookpages/1.json
  def destroy
    @bookpage.destroy
    respond_to do |format|
      format.html { redirect_to bookpages_url, notice: 'Bookpage was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_bookpage
      @bookpage = Bookpage.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def bookpage_params
      params.require(:bookpage).permit(:pagenum, :book_id, pictures: [])
    end
end
