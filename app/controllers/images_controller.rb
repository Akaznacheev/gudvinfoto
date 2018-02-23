class ImagesController < ApplicationController
  before_action :set_phgallery

  def create
    add_more_images(images_params[:images])
    flash[:error] = 'Ошибка загрузки фотографий' unless @phgallery.save
    redirect_back(fallback_location: (request.referer || root_path))
  end

  def destroy
    remove_image_at_index(params[:id].to_i)
    flash[:error] = 'Ошибка удаления фотографий' unless @phgallery.save
    redirect_back(fallback_location: (request.referer || root_path))
  end

  private

  def set_phgallery
    @phgallery = Phgallery.find(params[:phgallery_id])
  end

  def add_more_images(_new_images)
    images = @phgallery.images
    images += images_params[:images] # new_images
    @phgallery.images = images
  end

  def remove_image_at_index(index)
    @phgallery.images[index].try(:remove!) # delete image
    @phgallery['images'].delete_at(index) # remove from images array
    @phgallery.save
    @phgallery.reload # if you need to reference the new set of images
  end

  def images_params
    params.require(:phgallery).permit(images: []) # allow nested params as array
  end
end
