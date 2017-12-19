class ImagesController < ApplicationController
  before_action :set_phgallery

  def create
    add_more_images(images_params[:images])
    flash[:error] = 'Ошибка загрузки фотографий' unless @phgallery.save
    redirect_back(fallback_location: root_path)
  end

  def destroy
    remove_image_at_index(params[:id].to_i)
    flash[:error] = 'Ошибка удаления фотографий' unless @phgallery.save
    redirect_back(fallback_location: root_path)
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
    remain_images = @phgallery.images # copy the array
    deleted_image = remain_images.delete_at(index) # delete the target image
    deleted_image.try(:remove!) # delete image
    @phgallery.update(images: remain_images) # re-assign back
    @phgallery.remove_images! if remain_images.empty?
  end

  def images_params
    params.require(:phgallery).permit(images: []) # allow nested params as array
  end
end
