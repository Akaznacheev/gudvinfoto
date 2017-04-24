class VersusController < ApplicationController
  before_action :set_versu, only: [:show, :edit, :update, :destroy]

  # GET /versus
  # GET /versus.json
  def index
    @versus = Versu.all
  end

  # GET /versus/1
  # GET /versus/1.json
  def show
  end

  # GET /versus/new
  def new
    @versu = Versu.new
  end

  # GET /versus/1/edit
  def edit
  end

  # POST /versus
  # POST /versus.json
  def create
    @versu = Versu.new(versu_params)

    respond_to do |format|
      if @versu.save
        format.html { redirect_to @versu, notice: 'Versu was successfully created.' }
        format.json { render :show, status: :created, location: @versu }
      else
        format.html { render :new }
        format.json { render json: @versu.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /versus/1
  # PATCH/PUT /versus/1.json
  def update
    respond_to do |format|
      if @versu.update(versu_params)
        format.html { redirect_to @versu, notice: 'Versu was successfully updated.' }
        format.json { render :show, status: :ok, location: @versu }
      else
        format.html { render :edit }
        format.json { render json: @versu.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /versus/1
  # DELETE /versus/1.json
  def destroy
    @versu.destroy
    respond_to do |format|
      format.html { redirect_to versus_url, notice: 'Versu was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_versu
      @versu = Versu.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def versu_params
      params.require(:versu).permit(:name, :description)
    end
end
