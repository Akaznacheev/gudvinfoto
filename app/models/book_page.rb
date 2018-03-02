# == Schema Information
#
# Table name: book_pages
#
#  id               :integer          not null, primary key
#  page_num         :integer          default(0)
#  background_color :string           default("white")
#  template         :integer          default(0)
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#  images           :string           default([]), is an Array
#  positions        :string           default([]), is an Array
#  book_id          :integer
#  gallery_id       :integer
#  background       :string
#

class BookPage < ApplicationRecord
  belongs_to :book
  belongs_to :gallery

  def background_update(page, params)
    if params[:background_color]
      page.update(background_color: params[:background_color], background: nil)
      font_color_update(page.book, params) if page.page_num.zero?
    else
      page.update(background: page.gallery.images[params[:photo_id].to_i].url)
    end
  end

  def font_color_update(book, params)
    book.update(font_color: 'black') if params[:background_color] == 'white'
    book.update(font_color: 'white') if params[:background_color] == 'black'
  end

  def positions_update(page, move)
    positions = page.positions ||= []
    positions[move[:div_id].to_i] = move[:positions]
    page.update(positions: positions)
  end

  def template_update(page, template_num)
    page.update(template: template_num)
    if template_num > 100
      page2 = BookPage.find(page.id + 1)
      page2.update(images: [], positions: [], template: 0)
    elsif page.page_num.zero?
      puts page.page_num
      font_size = [2, 4, 6].include?(page.template) ? 6 : 3
      page.book.update(font_size: font_size)
    end
  end

  def add_image(page, photo)
    dragged_photo = page.gallery.images[photo[:photo_id].to_i]
    index = photo[:div_id].to_i
    # added_images_update
    added_images = page.gallery.added_images
    added_images -= [page.images[index]] if page.images[index].present?
    added_images << dragged_photo.url
    page.gallery.update(added_images: added_images)
    # image_update
    images = page.images
    images[index] = dragged_photo
    # positions_update
    positions = page.positions
    positions[index] = '0px 0px'
    page.update(images: images, positions: positions)
  end

  def page_image_rotate(page, image_num, rotate)
    image_object = page.gallery.images.find { |image| image.url == page.images[image_num] }
    file_image_rotate(image_object, rotate)
    page.positions[image_num] = '0px 0px'
    page.save
  end

  def file_image_rotate(image_object, rotate)
    url_files_to_rotate = [image_object.ineditor.path, image_object.path]
    url_files_to_rotate.each do |url|
      image_file = Magick::Image.read(url).first
      image_file.rotate!(rotate).write(url)
    end
  end
end
