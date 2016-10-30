module BookmakeHelper
  include Magick

  # Выбираем макет
  def template_choose(page)
    if page.template == 1
      merge_pagetemplate_1(page)
    end
    if page.template == 2
      merge_pagetemplate_2(page)
    end
    if page.template == 3
      merge_pagetemplate_3(page)
    end
    if page.template == 4
      merge_pagetemplate_4(page)
    end
    if page.template == 5
      merge_pagetemplate_5(page)
    end
    if page.template == 6
      merge_pagetemplate_6(page)
    end
    if page.template == 7
      merge_pagetemplate_7(page)
    end
    if page.template == 8
      merge_pagetemplate_8(page)
    end
    if page.template == 11
      merge_pagetemplate_11(page)
    end
  end

  # 1_Макет фото на всю страницу
  def merge_pagetemplate_1(page)
    photo         = Image.read([page.images.first.path][0])[0]
    framewidth    = @ypx
    frameheight   = @ypx
    movex         = (-page.positions[0].split('%')[0].to_f)*(frameheight*photo.columns-framewidth*photo.rows)/(100*photo.rows)
    movey         = (-page.positions[0].split('%')[1].to_f)*(framewidth*photo.rows-frameheight*photo.columns)/(100*photo.columns)
    if photo.columns > photo.rows
      photo         = photo.resize_to_fill(photo.columns*framewidth/photo.rows, frameheight)
    else
      photo         = photo.resize_to_fill(framewidth, photo.rows*(framewidth)/photo.columns)
    end
    photodone     = Magick::Image.new(framewidth, frameheight)
    photodone.composite!(photo, movex, movey, Magick::OverCompositeOp)
    @pages    << photodone
  end

  # 2_Макет фото по середине
  def merge_pagetemplate_2(page)
    background = Magick::Image.new(@ypx, @ypx) { self.background_color = page.bgcolor }
    photo         = Image.read([page.images.first.path][0])[0]
    framewidth    = 4*@ypx/5
    frameheight   = 4*@ypx/5
    movex         = (-page.positions[0].split('%')[0].to_f)*(frameheight*photo.columns-framewidth*photo.rows)/(100*photo.rows)
    movey         = (-page.positions[0].split('%')[1].to_f)*(framewidth*photo.rows-frameheight*photo.columns)/(100*photo.columns)
    if photo.columns > photo.rows
      photo         = photo.resize_to_fill(photo.columns*framewidth/photo.rows, frameheight)
    else
      photo         = photo.resize_to_fill(framewidth, photo.rows*(framewidth)/photo.columns)
    end
    photodone     = Magick::Image.new(framewidth, frameheight)
    photodone.composite!(photo, movex, movey, Magick::OverCompositeOp)
    @pages    << background.composite(photodone, Magick::NorthWestGravity, @ypx/10, @ypx/10, Magick::OverCompositeOp)
  end

  # 3_Макет фото по середине
  def merge_pagetemplate_3(page)
    background = Magick::Image.new(@ypx, @ypx) { self.background_color = page.bgcolor }
    photo         = Image.read([page.images.first.path][0])[0]
    framewidth    = 3*@ypx/5
    frameheight   = 3*@ypx/5
    movex         = (-page.positions[0].split('%')[0].to_f)*(frameheight*photo.columns-framewidth*photo.rows)/(100*photo.rows)
    movey         = (-page.positions[0].split('%')[1].to_f)*(framewidth*photo.rows-frameheight*photo.columns)/(100*photo.columns)
    if photo.columns > photo.rows
      photo         = photo.resize_to_fill(photo.columns*framewidth/photo.rows, frameheight)
    else
      photo         = photo.resize_to_fill(framewidth, photo.rows*(framewidth)/photo.columns)
    end
    photodone     = Magick::Image.new(framewidth, frameheight)
    photodone.composite!(photo, movex, movey, Magick::OverCompositeOp)
    @pages    << background.composite(photodone, Magick::NorthWestGravity, @ypx/5, @ypx/5, Magick::OverCompositeOp)
  end

  # 4_Макет фото по середине
  def merge_pagetemplate_4(page)
    background = Magick::Image.new(@ypx, @ypx) { self.background_color = page.bgcolor }
    photo         = Image.read([page.images.first.path][0])[0]
    framewidth    = 3*@ypx/5
    frameheight   = 3*@ypx/5
    movex         = (-page.positions[0].split('%')[0].to_f)*(frameheight*photo.columns-framewidth*photo.rows)/(100*photo.rows)
    movey         = (-page.positions[0].split('%')[1].to_f)*(framewidth*photo.rows-frameheight*photo.columns)/(100*photo.columns)
    if photo.columns > photo.rows
      photo         = photo.resize_to_fill(photo.columns*framewidth/photo.rows, frameheight)
    else
      photo         = photo.resize_to_fill(framewidth, photo.rows*(framewidth)/photo.columns)
    end
    photodone     = Magick::Image.new(framewidth, frameheight)
    photodone.composite!(photo, movex, movey, Magick::OverCompositeOp)
    @pages    << background.composite(photodone, Magick::NorthWestGravity, @ypx/5, @ypx/5, Magick::OverCompositeOp)
  end

  # 5_Макет фото по середине
  def merge_pagetemplate_5(page)
    background = Magick::Image.new(@ypx, @ypx) { self.background_color = page.bgcolor }
    photo         = Image.read([page.images.first.path][0])[0]
    framewidth    = 3*@ypx/5
    frameheight   = 3*@ypx/5
    movex         = (-page.positions[0].split('%')[0].to_f)*(frameheight*photo.columns-framewidth*photo.rows)/(100*photo.rows)
    movey         = (-page.positions[0].split('%')[1].to_f)*(framewidth*photo.rows-frameheight*photo.columns)/(100*photo.columns)
    if photo.columns > photo.rows
      photo         = photo.resize_to_fill(photo.columns*framewidth/photo.rows, frameheight)
    else
      photo         = photo.resize_to_fill(framewidth, photo.rows*(framewidth)/photo.columns)
    end
    photodone     = Magick::Image.new(framewidth, frameheight)
    photodone.composite!(photo, movex, movey, Magick::OverCompositeOp)
    @pages    << background.composite(photodone, Magick::NorthWestGravity, @ypx/5, @ypx/5, Magick::OverCompositeOp)
  end

  # 6_Макет
  def merge_pagetemplate_6(page)
    background = Magick::Image.new(@ypx, @ypx) { self.background_color = page.bgcolor }
    photo         = Image.read([page.images.first.path][0])[0]
    framewidth    = 3*@ypx/5
    frameheight   = @ypx
    movex         = (-page.positions[0].split('%')[0].to_f)*(frameheight*photo.columns-framewidth*photo.rows)/(100*photo.rows)
    movey         = (-page.positions[0].split('%')[1].to_f)*(framewidth*photo.rows-frameheight*photo.columns)/(100*photo.columns)
    if photo.columns > photo.rows
      photo         = photo.resize_to_fill(photo.columns*framewidth/photo.rows, frameheight)
    else
      photo         = photo.resize_to_fill(framewidth, photo.rows*(framewidth)/photo.columns)
    end
    photodone     = Magick::Image.new(framewidth, frameheight)
    photodone.composite!(photo, movex, movey, Magick::OverCompositeOp)
    @pages    << background.composite(photodone, Magick::NorthWestGravity, @ypx/5, 0, Magick::OverCompositeOp)
  end

  # 7_Макет
  def merge_pagetemplate_7(page)
    background = Magick::Image.new(@ypx, @ypx) { self.background_color = page.bgcolor }
    photo         = Image.read([page.images.first.path][0])[0]
    framewidth    = @ypx
    frameheight   = 3*@ypx/5
    movex         = (-page.positions[0].split('%')[0].to_f)*(frameheight*photo.columns-framewidth*photo.rows)/(100*photo.rows)
    movey         = (-page.positions[0].split('%')[1].to_f)*(framewidth*photo.rows-frameheight*photo.columns)/(100*photo.columns)
    if photo.columns > photo.rows
      photo         = photo.resize_to_fill(photo.columns*framewidth/photo.rows, frameheight)
    else
      photo         = photo.resize_to_fill(framewidth, photo.rows*(framewidth)/photo.columns)
    end
    photodone     = Magick::Image.new(framewidth, frameheight)
    photodone.composite!(photo, movex, movey, Magick::OverCompositeOp)
    @pages    << background.composite(photodone, Magick::NorthWestGravity, 0, @ypx/5, Magick::OverCompositeOp)
  end

  # 8_Макет
  def merge_pagetemplate_8(page)
    background = Magick::Image.new(@ypx, @ypx) { self.background_color = page.bgcolor }
    photo         = Image.read([page.images.first.path][0])[0]
    framewidth    = @ypx
    frameheight   = 3*@ypx/5
    movex         = (-page.positions[0].split('%')[0].to_f)*(frameheight*photo.columns-framewidth*photo.rows)/(100*photo.rows)
    movey         = (-page.positions[0].split('%')[1].to_f)*(framewidth*photo.rows-frameheight*photo.columns)/(100*photo.columns)
    if photo.columns > photo.rows
      photo         = photo.resize_to_fill(photo.columns*framewidth/photo.rows, frameheight)
    else
      photo         = photo.resize_to_fill(framewidth, photo.rows*(framewidth)/photo.columns)
    end
    photodone     = Magick::Image.new(framewidth, frameheight)
    photodone.composite!(photo, movex, movey, Magick::OverCompositeOp)
    @pages    << background.composite(photodone, Magick::NorthWestGravity, 0, @ypx/5, Magick::OverCompositeOp)
  end

  # 11_Макет
  def merge_pagetemplate_11(page)
    background = Magick::Image.new(@xpx, @ypx) { self.background_color = page.bgcolor }
    photo         = Image.read([page.images.first.path][0])[0]
    framewidth    = @xpx
    frameheight   = @ypx
    movex         = (-page.positions[0].split('%')[0].to_f)*(frameheight*photo.columns-framewidth*photo.rows)/(100*photo.rows)
    movey         = (-page.positions[0].split('%')[1].to_f)*(framewidth*photo.rows-frameheight*photo.columns)/(100*photo.columns)
    if photo.columns > photo.rows
      photo         = photo.resize_to_fill(photo.columns*framewidth/photo.rows, frameheight)
    else
      photo         = photo.resize_to_fill(framewidth, photo.rows*(framewidth)/photo.columns)
    end
    photodone     = Magick::Image.new(framewidth, frameheight)
    photodone.composite!(photo, movex, movey, Magick::OverCompositeOp)
    @pages    << background.composite(photodone, Magick::NorthWestGravity, 0, 0, Magick::OverCompositeOp)
  end

  # 12_Макет
  def merge_pagetemplate_12(page)
    background = Magick::Image.new(@xpx, @ypx) { self.background_color = page.bgcolor }
    photo         = Image.read([page.images.first.path][0])[0]
    framewidth    = @xpx
    frameheight   = @ypx
    movex         = (-page.positions[0].split('%')[0].to_f)*(frameheight*photo.columns-framewidth*photo.rows)/(100*photo.rows)
    movey         = (-page.positions[0].split('%')[1].to_f)*(framewidth*photo.rows-frameheight*photo.columns)/(100*photo.columns)
    if photo.columns > photo.rows
      photo         = photo.resize_to_fill(photo.columns*framewidth/photo.rows, frameheight)
    else
      photo         = photo.resize_to_fill(framewidth, photo.rows*(framewidth)/photo.columns)
    end
    photodone     = Magick::Image.new(framewidth, frameheight)
    photodone.composite!(photo, movex, movey, Magick::OverCompositeOp)
    @pages    << background.composite(photodone, Magick::NorthWestGravity, 0, 0, Magick::OverCompositeOp)
  end

  # 13_Макет
  def merge_pagetemplate_13(page)
    background = Magick::Image.new(@xpx, @ypx) { self.background_color = page.bgcolor }
    photo         = Image.read([page.images.first.path][0])[0]
    framewidth    = @xpx
    frameheight   = @ypx
    movex         = (-page.positions[0].split('%')[0].to_f)*(frameheight*photo.columns-framewidth*photo.rows)/(100*photo.rows)
    movey         = (-page.positions[0].split('%')[1].to_f)*(framewidth*photo.rows-frameheight*photo.columns)/(100*photo.columns)
    if photo.columns > photo.rows
      photo         = photo.resize_to_fill(photo.columns*framewidth/photo.rows, frameheight)
    else
      photo         = photo.resize_to_fill(framewidth, photo.rows*(framewidth)/photo.columns)
    end
    photodone     = Magick::Image.new(framewidth, frameheight)
    photodone.composite!(photo, movex, movey, Magick::OverCompositeOp)
    @pages    << background.composite(photodone, Magick::NorthWestGravity, 0, 0, Magick::OverCompositeOp)
  end

  # 14_Макет
  def merge_pagetemplate_14(page)
    background = Magick::Image.new(@xpx, @ypx) { self.background_color = page.bgcolor }
    photo         = Image.read([page.images.first.path][0])[0]
    framewidth    = @xpx
    frameheight   = @ypx
    movex         = (-page.positions[0].split('%')[0].to_f)*(frameheight*photo.columns-framewidth*photo.rows)/(100*photo.rows)
    movey         = (-page.positions[0].split('%')[1].to_f)*(framewidth*photo.rows-frameheight*photo.columns)/(100*photo.columns)
    if photo.columns > photo.rows
      photo         = photo.resize_to_fill(photo.columns*framewidth/photo.rows, frameheight)
    else
      photo         = photo.resize_to_fill(framewidth, photo.rows*(framewidth)/photo.columns)
    end
    photodone     = Magick::Image.new(framewidth, frameheight)
    photodone.composite!(photo, movex, movey, Magick::OverCompositeOp)
    @pages    << background.composite(photodone, Magick::NorthWestGravity, 0, 0, Magick::OverCompositeOp)
  end

  # 15_Макет
  def merge_pagetemplate_15(page)
    background = Magick::Image.new(@xpx, @ypx) { self.background_color = page.bgcolor }
    photo         = Image.read([page.images.first.path][0])[0]
    framewidth    = @xpx
    frameheight   = @ypx
    movex         = (-page.positions[0].split('%')[0].to_f)*(frameheight*photo.columns-framewidth*photo.rows)/(100*photo.rows)
    movey         = (-page.positions[0].split('%')[1].to_f)*(framewidth*photo.rows-frameheight*photo.columns)/(100*photo.columns)
    if photo.columns > photo.rows
      photo         = photo.resize_to_fill(photo.columns*framewidth/photo.rows, frameheight)
    else
      photo         = photo.resize_to_fill(framewidth, photo.rows*(framewidth)/photo.columns)
    end
    photodone     = Magick::Image.new(framewidth, frameheight)
    photodone.composite!(photo, movex, movey, Magick::OverCompositeOp)
    @pages    << background.composite(photodone, Magick::NorthWestGravity, 0, 0, Magick::OverCompositeOp)
  end

  # Склеиваем страницы
  def merge_2_page(pages)
    background = Magick::Image.new(@xpx, @ypx)
    razvorot   = background.composite(pages[0], Magick::NorthWestGravity, 0, 0, Magick::OverCompositeOp)
    if pages.count > 1
      razvorot   = razvorot.composite(pages[1], Magick::NorthEastGravity, 0, 0, Magick::OverCompositeOp)
    end
    directory_name = "public/uploads/order/" + @order.name
    Dir.mkdir(directory_name) unless File.exists?(directory_name)
    razvorot.write("public/uploads/order/"+ @order.name + "/razvorot_" + @rzvrtnum.to_s + ".jpg")
  end
end
