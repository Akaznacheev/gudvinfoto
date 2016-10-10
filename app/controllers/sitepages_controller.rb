class SitepagesController < ApplicationController
  before_action :set_sitepage, only: [:show, :edit, :update, :destroy]

  # GET /sitepages
  # GET /sitepages.json
  def index
    @sitepages = Sitepage.all
  end

  # GET /sitepages/1
  # GET /sitepages/1.json
  def show
  end

  # GET /sitepages/new
  def new
    @sitepage = Sitepage.new
  end

  # GET /sitepages/1/edit
  def edit
  end

  # POST /sitepages
  # POST /sitepages.json
  def create
    @sitepage = Sitepage.new(sitepage_params)

    respond_to do |format|
      if @sitepage.save
        format.html { redirect_to @sitepage, notice: 'Sitepage was successfully created.' }
        format.json { render :show, status: :created, location: @sitepage }
      else
        format.html { render :new }
        format.json { render json: @sitepage.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /sitepages/1
  # PATCH/PUT /sitepages/1.json
  def update
    respond_to do |format|
      if @sitepage.update(sitepage_params)
        format.html { redirect_to @sitepage, notice: 'Sitepage was successfully updated.' }
        format.json { render :show, status: :ok, location: @sitepage }
      else
        format.html { render :edit }
        format.json { render json: @sitepage.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /sitepages/1
  # DELETE /sitepages/1.json
  def destroy
    @sitepage.destroy
    respond_to do |format|
      format.html { redirect_to sitepages_url, notice: 'Sitepage was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_sitepage
      @sitepage = Sitepage.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def sitepage_params
      params.require(:sitepage).permit(:name, :text, :question, :answer)
    end
end
