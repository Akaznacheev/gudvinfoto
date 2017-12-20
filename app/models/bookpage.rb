# == Schema Information
#
# Table name: bookpages
#
#  id           :integer          not null, primary key
#  pagenum      :integer          default(0)
#  bgcolor      :string           default("white")
#  template     :integer          default(0)
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#  images       :string           default([]), is an Array
#  positions    :string           default([]), is an Array
#  book_id      :integer
#  phgallery_id :integer
#  background   :string
#

class Bookpage < ApplicationRecord
  belongs_to      :book
  belongs_to      :phgallery

  def background_update(page, params)
    if params[:bgcolor]
      page.update(bgcolor: params[:bgcolor], background: nil)
      font_color_update(page.book, params) if page.pagenum.zero?
    else
      page.update(background: page.phgallery.images[params[:photo_id].to_i].url)
    end
  end

  def font_color_update(book, params)
    book.update(fontcolor: 'black') if params[:bgcolor] == 'white'
    book.update(fontcolor: 'white') if params[:bgcolor] == 'black'
  end

  def positions_update(page, move)
    positions = page.positions ||= []
    positions[move[:div_id].to_i] = move[:positions]
    page.update(positions: positions)
  end

  def template_update(page, template_num)
    page.update(template: template_num)
    if template_num > 100
      page2 = Bookpage.find(page.id + 1)
      page2.update(images: [], positions: [], template: 0)
    elsif page.pagenum.zero?
      fontsize = [2, 4, 6].include?(page.pagenum) ? 6 : 3
      page.book.update(fontsize: fontsize)
    end
  end

  # TODO: refactor methods
  def add_image(page, photo)
    drag_photo = page.phgallery.images[photo[:photo_id].to_i]
    index = photo[:div_id].to_i
    # img_checks_update
    imgchecks = page.phgallery.imgchecks
    imgchecks -= [page.images[index]] if page.images[index].present?
    imgchecks << drag_photo.url
    page.phgallery.update(imgchecks: imgchecks)
    # image_update
    images = page.images
    images[index] = drag_photo
    # positions_update
    positions = page.positions
    positions[index] = '0px 0px'
    page.update(images: images, positions: positions)
  end

  def page_image_rotate(page, image_num, rotate)
    image_object = page.phgallery.images.find { |image| image.url == page.images[image_num] }
    image_file = Magick::Image.read(image_object.ineditor.path).first
    image_file.rotate!(rotate).write(image_object.ineditor.path)
    image_file = Magick::Image.read(image_object.path).first
    image_file.rotate!(rotate).write(image_object.path)
    image_object && image_file.destroy!
    page.positions[image_num] = '0px 0px'
    page.save
  end
end
