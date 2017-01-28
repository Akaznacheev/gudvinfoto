class PhgalleriesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_phgallery, only: [:show, :edit, :update, :destroy]

  def index
    @phgalleries = Phgallery.all
  end

  def show
  end

  def new
    @phgallery = Phgallery.new
  end

  def edit
  end

  def create
    @phgallery = Phgallery.new(phgallery_params)
      if @phgallery.save
        redirect_to @phgallery, notice: 'Phgallery was successfully created.'
      else
        render :new
      end
  end

  def update
      if @phgallery.update(phgallery_params)
        redirect_to @phgallery, notice: 'Phgallery was successfully updated.'
      else
        render :edit
      end
  end

  def destroy
    @phgallery.destroy
    redirect_to phgalleries_url, notice: 'Phgallery was successfully destroyed.'
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_phgallery
      @phgallery = Phgallery.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def phgallery_params
      params[:phgallery].permit(:kind, {images: []})
    end
end
