class SocialiconsController < ApplicationController
  before_action :set_socialicon, only: [:show, :edit, :update, :destroy]

  # GET /socialicons
  # GET /socialicons.json
  def index
    @socialicons = Socialicon.all
  end

  # GET /socialicons/1
  # GET /socialicons/1.json
  def show
  end

  # GET /socialicons/new
  def new
    @socialicon = Socialicon.new
  end

  # GET /socialicons/1/edit
  def edit
  end

  # POST /socialicons
  # POST /socialicons.json
  def create
    @socialicon = Socialicon.new(socialicon_params)

    respond_to do |format|
      if @socialicon.save
        format.html { redirect_to @socialicon, notice: 'Socialicon was successfully created.' }
        format.json { render :show, status: :created, location: @socialicon }
      else
        format.html { render :new }
        format.json { render json: @socialicon.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /socialicons/1
  # PATCH/PUT /socialicons/1.json
  def update
    respond_to do |format|
      if @socialicon.update(socialicon_params)
        format.html { redirect_to @socialicon, notice: 'Socialicon was successfully updated.' }
        format.json { render :show, status: :ok, location: @socialicon }
      else
        format.html { render :edit }
        format.json { render json: @socialicon.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /socialicons/1
  # DELETE /socialicons/1.json
  def destroy
    @socialicon.destroy
    respond_to do |format|
      format.html { redirect_to socialicons_url, notice: 'Socialicon was successfully destroyed.' }
      format.json { head :no_content }
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
