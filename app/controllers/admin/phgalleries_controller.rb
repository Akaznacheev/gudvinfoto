module Admin
  class PhgalleriesController < AdminController
    before_action :set_phgallery, only: %i[show edit update destroy]

    def index
      @phgallery = Phgallery.find_by(kind: 'homepage')
      @background = Phgallery.find_by(kind: 'background')
    end

    def edit; end

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

    def set_phgallery
      @phgallery = Phgallery.find(params[:id])
    end

    def phgallery_params
      params[:phgallery].permit(:kind, images: [])
    end
  end
end
