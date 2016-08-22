class ImagesController < ApplicationController
  before_action :set_phgallery

  def create
    add_more_images(images_params[:images])
    flash[:error] = "Ошибка загрузки фотографий" unless @phgallery.save
    redirect_to :back
  end

  def destroy
    remove_image_at_index(params[:id].to_i)
    flash[:error] = "Ошибка удаления фотографий" unless @phgallery.save
    redirect_to :back
  end

  private

  def set_phgallery
    @phgallery = Phgallery.find(params[:phgallery_id])
  end

  def add_more_images(new_images)
    images = @phgallery.images
    images += new_images
    @phgallery.images = images
  end

  def remove_image_at_index(index)
    remain_images = @phgallery.images # copy the array
    deleted_image = remain_images.delete_at(index) # delete the target image
    deleted_image.try(:remove!) # delete image from S3
    @phgallery.images = remain_images # re-assign back
  end

  def images_params
    params.require(:phgallery).permit({images: []}) # allow nested params as array
  end
end