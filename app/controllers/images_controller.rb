class ImagesController < ApplicationController
  before_action :set_gallery

  def create
    add_more_images(images_params[:images])
    flash[:error] = 'Ошибка загрузки фотографий' unless @gallery.save
    redirect_back(fallback_location: (request.referer || root_path))
  end

  def destroy
    remove_image_at_index(params[:id].to_i)
    flash[:error] = 'Ошибка удаления фотографий' unless @gallery.save
    redirect_back(fallback_location: (request.referer || root_path))
  end

  private

  def set_gallery
    @gallery = Gallery.find(params[:gallery_id])
  end

  def add_more_images(_new_images)
    images = @gallery.images
    images += images_params[:images] # new_images
    @gallery.images = images
  end

  def remove_image_at_index(index)
    @gallery.images[index].try(:remove!) # delete image
    @gallery['images'].delete_at(index) # remove from images array
    @gallery.save
    @gallery.reload # if you need to reference the new set of images
  end

  def images_params
    params.require(:gallery).permit(images: []) # allow nested params as array
  end
end
