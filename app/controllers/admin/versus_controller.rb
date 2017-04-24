class VersusController < ApplicationController
  before_action :set_versu, only: [:show, :edit, :update, :destroy]

  def index
    @versus = Versu.all
  end

  def show
  end

  def new
    @versu = Versu.new
  end

  def edit
  end

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

  def destroy
    @versu.destroy
    respond_to do |format|
      format.html { redirect_to versus_url, notice: 'Versu was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    def set_versu
      @versu = Versu.find(params[:id])
    end

    def versu_params
      params.require(:versu).permit(:name, :description)
    end
end
