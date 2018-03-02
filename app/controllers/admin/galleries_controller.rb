module Admin
  class GalleriesController < AdminController
    before_action :set_gallery, only: %i[show edit update destroy]

    def index
      @gallery = Gallery.find_by(kind: 'homepage')
      @background = Gallery.find_by(kind: 'background')
    end

    def edit; end

    def update
      if @gallery.update(gallery_params)
        redirect_to @gallery, notice: 'Gallery was successfully updated.'
      else
        render :edit
      end
    end

    def destroy
      @gallery.destroy
      redirect_to galleries_url, notice: 'Gallery was successfully destroyed.'
    end

    private

    def set_gallery
      @gallery = Gallery.find(params[:id])
    end

    def gallery_params
      params[:gallery].permit(:kind, images: [])
    end
  end
end
