module BookmakeHelper
  include Magick

  # Выбираем макет
  def template_choose(page)
    send(:"merge_pagetemplate_#{page.template}", page)
  end

  #Заполнение фрейма изображением
  def resize_to_fill(photo, fw, fh)
    if fw/fh.to_f > photo.columns/photo.rows.to_f
      photo = photo.resize_to_fill( fw , photo.rows*fw/photo.columns)
    else
      photo = photo.resize_to_fill( photo.columns*fh/photo.rows , fh)
    end
    return photo
  end

  #Сдвиг изображения внутри фрейма
  def translation(page, photo, fw, fh, i)
    movex         = (-page.positions[i].split('%')[0].to_f)*(fh*photo.columns-fw*photo.rows)/(100*photo.rows)
    movey         = (-page.positions[i].split('%')[1].to_f)*(fw*photo.rows-fh*photo.columns)/(100*photo.columns)
    return [movex, movey]
  end

  # Задник
  def backside_cover(page, framewidth, frameheight)
    backsidecover   = Magick::Image.new(framewidth, frameheight) { self.background_color = page.bgcolor }
    logo            = Image.read("app/assets/images/backsidelogo.png")[0]
    if page.book.bookprice.format == "10см*10см"
      logo = logo.resize_to_fill( logo.columns/2 , logo.rows/2)
    elsif page.book.bookprice.format == "15см*15см"
      logo = logo.resize_to_fill( logo.columns*3/4 , logo.rows*3/4)
    end
    @backsidecover  = backsidecover.composite(logo, Magick::CenterGravity, 0, 0.25*frameheight, Magick::OverCompositeOp)
  end

  # Отстав
  def otstav(page, coverypx, otstavheight)
    texttopaste = page.book.name
    otstav = Magick::Image.new(coverypx, otstavheight) { self.background_color = page.bgcolor }
    text = Magick::Draw.new
    text.font = "public/assets/fonts/" + page.book.fontfamily + ".ttf"
    text.pointsize = 0.6 * otstav.rows
    text.gravity = Magick::CenterGravity
    text.fill = page.book.fontcolor
    text.annotate(otstav, 0,0,0,0, texttopaste)
    if page.bgcolor == "white"
      text.stroke('Black')
    else
      text.stroke('White')
    end
    text.stroke_width(10)
    text.line(0, otstavheight, 75, otstavheight)
    text.line(coverypx, otstavheight, coverypx-75, otstavheight)
    text.draw(otstav)
    @otstav = otstav
  end

  # 1_макет обложки
  def frontcover_1(page, framewidth, frameheight)
    photo             = Image.read([page.images.first.path][0])[0]
    imageframewidth   = 0.6*frameheight
    imageframeheight  = 0.6*frameheight
    textframewidth    = framewidth
    textframeheight   = 0.3*frameheight
    move              = translation(page, photo, imageframewidth, imageframeheight, 0)
    photo             = resize_to_fill(photo, imageframewidth, imageframeheight)
    imageframe        = Magick::Image.new(imageframewidth, imageframeheight)
    imageframe.composite!(photo, move[0], move[1], Magick::OverCompositeOp)

    @text = page.book.name
    textframe = Magick::Image.new(textframewidth, textframeheight) { self.background_color = page.bgcolor }
    text = Magick::Draw.new
    text.font = "public/assets/fonts/" + page.book.fontfamily + ".ttf"
    text.pointsize = page.book.fontsize.to_i * 0.01 * frameheight * 2
    text.gravity = Magick::CenterGravity
    text.fill = page.book.fontcolor
    text.annotate(textframe, 0,0,0,0, @text)

    frontcover = Magick::Image.new(framewidth, frameheight) { self.background_color = page.bgcolor }
    frontcover   = frontcover.composite(imageframe, Magick::NorthWestGravity, 0.2*frameheight, 0.1*frameheight, Magick::OverCompositeOp)
    frontcover   = frontcover.composite(textframe, Magick::NorthWestGravity, 0, imageframeheight+0.1*frameheight, Magick::OverCompositeOp)
    @frontcover = frontcover
  end

  # 2_макет обложки
  def frontcover_2(page, framewidth, frameheight)
    photo         = Image.read([page.images.first.path][0])[0]
    imageframewidth   = 0.45*frameheight
    imageframeheight  = 0.45*frameheight
    textframewidth    = 0.45*frameheight
    textframeheight   = 0.45*frameheight
    move              = translation(page, photo, imageframewidth, imageframeheight, 0)
    photo             = resize_to_fill(photo, imageframewidth, imageframeheight)
    imageframe     = Magick::Image.new(imageframewidth, imageframeheight)
    imageframe.composite!(photo, move[0], move[1], Magick::OverCompositeOp)

    @text = page.book.name
    textframe = Magick::Image.new(textframewidth, textframeheight) { self.background_color = page.bgcolor }
    text = Magick::Draw.new
    text.font = "public/assets/fonts/" + page.book.fontfamily + ".ttf"
    text.pointsize = page.book.fontsize.to_i * 0.01 * frameheight * 2
    text.gravity = Magick::CenterGravity
    text.fill = page.book.fontcolor
    text.annotate(textframe, 0,0,0,0, @text)

    frontcover = Magick::Image.new(framewidth, frameheight) { self.background_color = page.bgcolor }
    frontcover   = frontcover.composite(imageframe, Magick::NorthWestGravity, 0.05*frameheight, 0.275*frameheight, Magick::OverCompositeOp)
    frontcover   = frontcover.composite(textframe, Magick::NorthWestGravity, 0.5*frameheight, 0.275*frameheight, Magick::OverCompositeOp)
    @frontcover = frontcover
  end

  # 3_макет обложки
  def frontcover_3(page, framewidth, frameheight)
    photo         = Image.read([page.images.first.path][0])[0]
    imageframewidth   = framewidth
    imageframeheight  = 0.7*frameheight
    textframewidth    = framewidth
    textframeheight   = 0.3*frameheight
    move              = translation(page, photo, imageframewidth, imageframeheight, 0)
    photo             = resize_to_fill(photo, imageframewidth, imageframeheight)
    imageframe     = Magick::Image.new(imageframewidth, imageframeheight)
    imageframe.composite!(photo, move[0], move[1], Magick::OverCompositeOp)

    @text = page.book.name
    textframe = Magick::Image.new(textframewidth, textframeheight) { self.background_color = page.bgcolor }
    text = Magick::Draw.new
    text.font = "public/assets/fonts/" + page.book.fontfamily + ".ttf"
    text.pointsize = page.book.fontsize.to_i * 0.01 * frameheight * 2
    text.gravity = Magick::CenterGravity
    text.fill = page.book.fontcolor
    text.annotate(textframe, 0,0,0,0, @text)

    frontcover = Magick::Image.new(framewidth, frameheight) { self.background_color = page.bgcolor }
    frontcover   = frontcover.composite(imageframe, Magick::NorthWestGravity, 0, 0, Magick::OverCompositeOp)
    frontcover   = frontcover.composite(textframe, Magick::NorthWestGravity, 0, imageframeheight, Magick::OverCompositeOp)
    @frontcover = frontcover
  end

  # 4_макет обложки
  def frontcover_4(page, framewidth, frameheight)
    photo         = Image.read([page.images.first.path][0])[0]
    imageframewidth   = 0.45*frameheight
    imageframeheight  = 0.9*frameheight
    textframewidth    = 0.45*frameheight
    textframeheight   = 0.45*frameheight
    move              = translation(page, photo, imageframewidth, imageframeheight, 0)
    photo             = resize_to_fill(photo, imageframewidth, imageframeheight)
    imageframe     = Magick::Image.new(imageframewidth, imageframeheight)
    imageframe.composite!(photo, move[0], move[1], Magick::OverCompositeOp)

    @text = page.book.name
    textframe = Magick::Image.new(textframewidth, textframeheight) { self.background_color = page.bgcolor }
    text = Magick::Draw.new
    text.font = "public/assets/fonts/" + page.book.fontfamily + ".ttf"
    text.pointsize = page.book.fontsize.to_i * 0.01 * frameheight * 2
    text.gravity = Magick::CenterGravity
    text.fill = page.book.fontcolor
    text.annotate(textframe, 0,0,0,0, @text)

    frontcover = Magick::Image.new(framewidth, frameheight) { self.background_color = page.bgcolor }
    frontcover   = frontcover.composite(imageframe, Magick::NorthWestGravity, 0.05*frameheight, 0.05*frameheight, Magick::OverCompositeOp)
    frontcover   = frontcover.composite(textframe, Magick::NorthWestGravity, 0.5*frameheight, 0.275*frameheight, Magick::OverCompositeOp)
    @frontcover = frontcover
  end

  # 5_макет обложки
  def frontcover_5(page, framewidth, frameheight)
    @text = page.book.name
    frontcover = Magick::Image.new(framewidth, frameheight) { self.background_color = page.bgcolor }
    text = Magick::Draw.new
    text.font = "public/assets/fonts/" + page.book.fontfamily + ".ttf"
    text.pointsize = page.book.fontsize.to_i * 0.01 * frameheight * 2
    text.gravity = Magick::CenterGravity
    text.fill = page.book.fontcolor
    text.annotate(frontcover, 0,0,0,0, @text)
    @frontcover = frontcover
  end

  # 6_макет обложки
  def frontcover_6(page, framewidth, frameheight)
    imageframewidth   = 0.2235*frameheight
    imageframeheight  = 0.2235*frameheight
    textframewidth    = 0.447*frameheight+framewidth/500
    textframeheight   = 0.2235*frameheight

    @text = page.book.name
    textframe = Magick::Image.new(textframewidth, textframeheight) { self.background_color = page.bgcolor }
    text = Magick::Draw.new
    text.font = "public/assets/fonts/" + page.book.fontfamily + ".ttf"
    text.pointsize = page.book.fontsize.to_i * 0.01 * frameheight * 2
    text.gravity = Magick::CenterGravity
    text.fill = page.book.fontcolor
    text.annotate(textframe, 0,0,0,0, @text)

    background = Magick::Image.new(framewidth, frameheight) { self.background_color = page.bgcolor }
    photodone         = []
    (0..13).each do |i|
      photo           = Image.read([page.images[i].path][0])[0]
      move            = translation(page, photo, imageframewidth, imageframeheight, i)
      photo           = resize_to_fill(photo, imageframewidth, imageframeheight)
      photodone[i]    = Magick::Image.new(imageframewidth, imageframeheight)
      photodone[i].composite!(photo, move[0], move[1], Magick::OverCompositeOp)
    end

    frontcover = background.composite(photodone[0], Magick::NorthWestGravity, framewidth/20, frameheight/20, Magick::OverCompositeOp)
    frontcover = frontcover.composite(photodone[1], Magick::NorthWestGravity, framewidth/20+imageframewidth+framewidth/500, frameheight/20, Magick::OverCompositeOp)
    frontcover = frontcover.composite(photodone[2], Magick::NorthWestGravity, framewidth/20+2*imageframewidth+2*framewidth/500, frameheight/20, Magick::OverCompositeOp)
    frontcover = frontcover.composite(photodone[3], Magick::NorthWestGravity, framewidth/20+3*imageframewidth+3*framewidth/500, frameheight/20, Magick::OverCompositeOp)
    frontcover = frontcover.composite(photodone[4], Magick::NorthWestGravity, framewidth/20, frameheight/20+imageframeheight+frameheight/500, Magick::OverCompositeOp)
    frontcover = frontcover.composite(photodone[5], Magick::NorthWestGravity, framewidth/20+imageframewidth+framewidth/500, frameheight/20+imageframeheight+frameheight/500, Magick::OverCompositeOp)
    frontcover = frontcover.composite(photodone[6], Magick::NorthWestGravity, framewidth/20+2*imageframewidth+2*framewidth/500, frameheight/20+imageframeheight+frameheight/500, Magick::OverCompositeOp)
    frontcover = frontcover.composite(photodone[7], Magick::NorthWestGravity, framewidth/20+3*imageframewidth+3*framewidth/500, frameheight/20+imageframeheight+frameheight/500, Magick::OverCompositeOp)
    frontcover = frontcover.composite(photodone[8], Magick::NorthWestGravity, framewidth/20, frameheight/20+2*imageframeheight+2*frameheight/500, Magick::OverCompositeOp)
    frontcover = frontcover.composite(photodone[9], Magick::NorthWestGravity, framewidth/20+imageframewidth+framewidth/500, frameheight/20+2*imageframeheight+2*frameheight/500, Magick::OverCompositeOp)
    frontcover = frontcover.composite(textframe, Magick::NorthWestGravity, framewidth/20+2*imageframewidth+2*framewidth/500, frameheight/20+2*imageframeheight+2*frameheight/500, Magick::OverCompositeOp)
    frontcover = frontcover.composite(photodone[10], Magick::NorthWestGravity, framewidth/20, frameheight/20+3*imageframeheight+3*framewidth/500, Magick::OverCompositeOp)
    frontcover = frontcover.composite(photodone[11], Magick::NorthWestGravity, framewidth/20+imageframewidth+framewidth/500, frameheight/20+3*imageframeheight+3*frameheight/500, Magick::OverCompositeOp)
    frontcover = frontcover.composite(photodone[12], Magick::NorthWestGravity, framewidth/20+2*imageframewidth+2*framewidth/500, frameheight/20+3*imageframeheight+3*frameheight/500, Magick::OverCompositeOp)
    frontcover = frontcover.composite(photodone[13], Magick::NorthWestGravity, framewidth/20+3*imageframewidth+3*framewidth/500, frameheight/20+3*imageframeheight+3*frameheight/500, Magick::OverCompositeOp)
    @frontcover = frontcover
  end

  # сборка обложки
  def cover_create(page)
    coverypx = page.book.bookprice.coverheight
    coverxpx = page.book.bookprice.coverwidth + ((page.book.bookpages.count-1)/2-10)*11.811
    klapan = 15*11.811
    otstavheight = 11.811 * (page.book.bookpages.count-1)/2
    framewidth    = (coverxpx-2*klapan-otstavheight)/2
    frameheight   = coverypx-2*klapan

    send(:"frontcover_#{page.template}", page, framewidth, frameheight)
    otstav(page, coverypx, otstavheight)
    backside_cover(page, framewidth, frameheight)

    background = Magick::Image.new(coverxpx, coverypx ){ self.background_color = page.bgcolor }
    cover   = background.composite(@backsidecover, Magick::NorthWestGravity, klapan, klapan, Magick::OverCompositeOp)
    cover   = cover.composite(@otstav.rotate(-90), Magick::NorthWestGravity, framewidth+klapan, 0, Magick::OverCompositeOp)
    cover   = cover.composite(@frontcover, Magick::NorthWestGravity, framewidth+klapan+otstavheight, klapan, Magick::OverCompositeOp)
    cover.units = Magick::PixelsPerInchResolution
    cover.density = "300x300"
    directory_name = "public/orders/" + @order.name
    Dir.mkdir(directory_name) unless File.exists?(directory_name)
    cover.write(directory_name + "/00.jpg")
  end

  # 1_Макет фото на всю страницу
  def merge_pagetemplate_1(page)
    photo         = Image.read([page.images.first.path][0])[0]
    framewidth    = @ypx
    frameheight   = @ypx
    move          = translation(page, photo, framewidth, frameheight, 0)
    photo         = resize_to_fill(photo, framewidth, frameheight)
    photodone     = Magick::Image.new(framewidth, frameheight)
    photodone.composite!(photo, Magick::NorthWestGravity, move[0], move[1], Magick::OverCompositeOp)
    @pages    << photodone
  end

  # 2_Макет фото по середине
  def merge_pagetemplate_2(page)
    background = Magick::Image.new(@ypx, @ypx) { self.background_color = page.bgcolor }
    photo         = Image.read([page.images.first.path][0])[0]
    framewidth    = 4*@ypx/5
    frameheight   = 4*@ypx/5
    move          = translation(page, photo, framewidth, frameheight, 0)
    photo         = resize_to_fill(photo, framewidth, frameheight)
    photodone     = Magick::Image.new(framewidth, frameheight)
    photodone.composite!(photo, move[0], move[1], Magick::OverCompositeOp)
    @pages    << background.composite(photodone, Magick::NorthWestGravity, @ypx/10, @ypx/10, Magick::OverCompositeOp)
  end

  # 3_Макет фото по середине
  def merge_pagetemplate_3(page)
    background = Magick::Image.new(@ypx, @ypx) { self.background_color = page.bgcolor }
    photo         = Image.read([page.images.first.path][0])[0]
    framewidth    = 3*@ypx/5
    frameheight   = 3*@ypx/5
    move          = translation(page, photo, framewidth, frameheight, 0)
    photo         = resize_to_fill(photo, framewidth, frameheight)
    photodone     = Magick::Image.new(framewidth, frameheight)
    photodone.composite!(photo, move[0], move[1], Magick::OverCompositeOp)
    @pages    << background.composite(photodone, Magick::NorthWestGravity, @ypx/5, @ypx/5, Magick::OverCompositeOp)
  end

  # 4_Макет
  def merge_pagetemplate_4(page)
    background = Magick::Image.new(@ypx, @ypx) { self.background_color = page.bgcolor }
    framewidth    = 0.33*(4*@ypx/5)
    frameheight   = 0.33*(4*@ypx/5)
    photodone     = []
    (0..8).each do |i|
      photo         = Image.read([page.images[i].path][0])[0]
      move          = translation(page, photo, framewidth, frameheight, i)
      photo         = resize_to_fill(photo, framewidth, frameheight)
      photodone[i]     = Magick::Image.new(framewidth, frameheight)
      photodone[i].composite!(photo, move[0], move[1], Magick::OverCompositeOp)
    end
    @page = background.composite(photodone[0], Magick::NorthWestGravity, @ypx/10, @ypx/10, Magick::OverCompositeOp)
    @page = @page.composite(photodone[1], Magick::NorthWestGravity, 0.335*(4*@ypx/5)+@ypx/10, @ypx/10, Magick::OverCompositeOp)
    @page = @page.composite(photodone[2], Magick::NorthWestGravity, 0.67*(4*@ypx/5)+@ypx/10, @ypx/10, Magick::OverCompositeOp)
    @page = @page.composite(photodone[3], Magick::NorthWestGravity, @ypx/10, 0.335*(4*@ypx/5)+@ypx/10, Magick::OverCompositeOp)
    @page = @page.composite(photodone[4], Magick::NorthWestGravity, 0.335*(4*@ypx/5)+@ypx/10, 0.335*(4*@ypx/5)+@ypx/10, Magick::OverCompositeOp)
    @page = @page.composite(photodone[5], Magick::NorthWestGravity, 0.67*(4*@ypx/5)+@ypx/10, 0.335*(4*@ypx/5)+@ypx/10, Magick::OverCompositeOp)
    @page = @page.composite(photodone[6], Magick::NorthWestGravity, @ypx/10, 0.67*(4*@ypx/5)+@ypx/10, Magick::OverCompositeOp)
    @page = @page.composite(photodone[7], Magick::NorthWestGravity, 0.335*(4*@ypx/5)+@ypx/10, 0.67*(4*@ypx/5)+@ypx/10, Magick::OverCompositeOp)
    @page = @page.composite(photodone[8], Magick::NorthWestGravity, 0.67*(4*@ypx/5)+@ypx/10, 0.67*(4*@ypx/5)+@ypx/10, Magick::OverCompositeOp)
    @pages << @page
  end

  # 5_Макет
  def merge_pagetemplate_5(page)
    background = Magick::Image.new(@ypx, @ypx) { self.background_color = page.bgcolor }
    framewidth    = 0.495*(9*@ypx/10)
    frameheight   = 0.33*(9*@ypx/10)
    photodone     = []
    (0..3).each do |i|
      if i > 2
        framewidth    = 0.495*(9*@ypx/10)
        frameheight   = 9*@ypx/10
      end
      photo         = Image.read([page.images[i].path][0])[0]
      move          = translation(page, photo, framewidth, frameheight, i)
      photo         = resize_to_fill(photo, framewidth, frameheight)
      photodone[i]     = Magick::Image.new(framewidth, frameheight)
      photodone[i].composite!(photo, move[0], move[1], Magick::OverCompositeOp)
    end
    @page = background.composite(photodone[0], Magick::NorthWestGravity, @ypx/20, @ypx/20, Magick::OverCompositeOp)
    @page = @page.composite(photodone[1], Magick::NorthWestGravity, @ypx/20, 0.335*(9*@ypx/10)+@ypx/20, Magick::OverCompositeOp)
    @page = @page.composite(photodone[2], Magick::NorthWestGravity, @ypx/20, 0.67*(9*@ypx/10)+@ypx/20, Magick::OverCompositeOp)
    @page = @page.composite(photodone[3], Magick::NorthWestGravity, 0.5*(9*@ypx/10)+@ypx/20, @ypx/20, Magick::OverCompositeOp)
    @pages << @page
  end

  # 6_Макет
  def merge_pagetemplate_6(page)
    background = Magick::Image.new(@ypx, @ypx) { self.background_color = page.bgcolor }
    photo         = Image.read([page.images.first.path][0])[0]
    framewidth    = 3*@ypx/5
    frameheight   = @ypx
    move          = translation(page, photo, framewidth, frameheight, 0)
    photo         = resize_to_fill(photo, framewidth, frameheight)
    photodone     = Magick::Image.new(framewidth, frameheight)
    photodone.composite!(photo, move[0], move[1], Magick::OverCompositeOp)
    @pages    << background.composite(photodone, Magick::NorthWestGravity, @ypx/5, 0, Magick::OverCompositeOp)
  end

  # 7_Макет
  def merge_pagetemplate_7(page)
    background = Magick::Image.new(@ypx, @ypx) { self.background_color = page.bgcolor }
    photo         = Image.read([page.images.first.path][0])[0]
    framewidth    = @ypx
    frameheight   = 3*@ypx/5
    move          = translation(page, photo, framewidth, frameheight, 0)
    photo         = resize_to_fill(photo, framewidth, frameheight)
    photodone     = Magick::Image.new(framewidth, frameheight)
    photodone.composite!(photo, move[0], move[1], Magick::OverCompositeOp)
    @pages    << background.composite(photodone, Magick::NorthWestGravity, 0, @ypx/5, Magick::OverCompositeOp)
  end

  # 8_Макет
  def merge_pagetemplate_8(page)
    background = Magick::Image.new(@ypx, @ypx) { self.background_color = page.bgcolor }
    framewidth    = 0.495*@ypx
    frameheight   = 0.495*(3*@ypx/5)
    photodone     = []
    (0..3).each do |i|
      photo         = Image.read([page.images[i].path][0])[0]
      move          = translation(page, photo, framewidth, frameheight, i)
      photo         = resize_to_fill(photo, framewidth, frameheight)
      photodone[i]  = Magick::Image.new(framewidth, frameheight)
      photodone[i].composite!(photo, move[0], move[1], Magick::OverCompositeOp)
    end
    @page = background.composite(photodone[0], Magick::NorthWestGravity, 0, @ypx/5, Magick::OverCompositeOp)
    @page = @page.composite(photodone[1], Magick::NorthWestGravity, 0.5*@ypx, @ypx/5, Magick::OverCompositeOp)
    @page = @page.composite(photodone[2], Magick::NorthWestGravity, 0, 0.505*(3*@ypx/5)+@ypx/5, Magick::OverCompositeOp)
    @page = @page.composite(photodone[3], Magick::NorthWestGravity, 0.5*@ypx, 0.505*(3*@ypx/5)+@ypx/5, Magick::OverCompositeOp)
    @pages << @page
  end

  # 11_Макет
  def merge_pagetemplate_11(page)
    background = Magick::Image.new(@xpx, @ypx) { self.background_color = page.bgcolor }
    photo         = Image.read([page.images.first.path][0])[0]
    framewidth    = @xpx
    frameheight   = @ypx
    move          = translation(page, photo, framewidth, frameheight, 0)
    photo         = resize_to_fill(photo, framewidth, frameheight)
    photodone     = Magick::Image.new(framewidth, frameheight)
    photodone.composite!(photo, move[0], move[1], Magick::OverCompositeOp)
    @pages    << background.composite(photodone, Magick::NorthWestGravity, 0, 0, Magick::OverCompositeOp)
  end

  # 12_Макет
  def merge_pagetemplate_12(page)
    background = Magick::Image.new(@xpx, @ypx) { self.background_color = page.bgcolor }
    framewidth    = 0.75*@xpx
    frameheight   = @ypx
    photodone     = []
    (0..3).each do |i|
      if i > 0
        framewidth    = 0.25*(9*@xpx/10)
        frameheight   = 0.33*9*@ypx/10
      end
      photo         = Image.read([page.images[i].path][0])[0]
      move          = translation(page, photo, framewidth, frameheight, i)
      photo         = resize_to_fill(photo, framewidth, frameheight)
      photodone[i]     = Magick::Image.new(framewidth, frameheight)
      photodone[i].composite!(photo, move[0], move[1], Magick::OverCompositeOp)
    end
    @page = background.composite(photodone[0], Magick::NorthWestGravity, 0, 0, Magick::OverCompositeOp)
    @page = @page.composite(photodone[1], Magick::NorthWestGravity, 0.75*@xpx+@ypx/40, @ypx/40, Magick::OverCompositeOp)
    @page = @page.composite(photodone[2], Magick::NorthWestGravity, 0.75*@xpx+@ypx/40, 0.335*(9*@ypx/10)+2*@ypx/40, Magick::OverCompositeOp)
    @page = @page.composite(photodone[3], Magick::NorthWestGravity, 0.75*@xpx+@ypx/40, 0.67*(9*@ypx/10)+3*@ypx/40, Magick::OverCompositeOp)
    @pages << @page
  end

  # 13_Макет
  def merge_pagetemplate_13(page)
    background = Magick::Image.new(@xpx, @ypx) { self.background_color = page.bgcolor }
    framewidth    = 0.25*(9*@xpx/10)
    frameheight   = 0.33*9*@ypx/10
    photodone     = []
    (0..3).each do |i|
      if i > 2
        framewidth    = 0.75*@xpx
        frameheight   = @ypx
      end
      photo         = Image.read([page.images[i].path][0])[0]
      move          = translation(page, photo, framewidth, frameheight, i)
      photo         = resize_to_fill(photo, framewidth, frameheight)
      puts photo.rows, photo.columns
      photodone[i]     = Magick::Image.new(framewidth, frameheight)
      photodone[i].composite!(photo, move[0], move[1], Magick::OverCompositeOp)
    end
    @page = background.composite(photodone[0], Magick::NorthWestGravity, @ypx/40, @ypx/40, Magick::OverCompositeOp)
    @page = @page.composite(photodone[1], Magick::NorthWestGravity, @ypx/40, 0.335*(9*@ypx/10)+2*@ypx/40, Magick::OverCompositeOp)
    @page = @page.composite(photodone[2], Magick::NorthWestGravity, @ypx/40, 0.67*(9*@ypx/10)+3*@ypx/40, Magick::OverCompositeOp)
    @page = @page.composite(photodone[3], Magick::NorthWestGravity, 0.25*@xpx, 0, Magick::OverCompositeOp)
    @pages << @page
  end

  # 14_Макет
  def merge_pagetemplate_14(page)
    background = Magick::Image.new(@xpx, @ypx) { self.background_color = page.bgcolor }
    framewidth    = 0.75*@xpx
    frameheight   = @ypx
    photodone     = []
    (0..1).each do |i|
      if i > 0
        framewidth    = 0.245*@xpx
        frameheight   = @ypx
      end
      photo         = Image.read([page.images[i].path][0])[0]
      move          = translation(page, photo, framewidth, frameheight, i)
      photo         = resize_to_fill(photo, framewidth, frameheight)
      photodone[i]     = Magick::Image.new(framewidth, frameheight)
      photodone[i].composite!(photo, move[0], move[1], Magick::OverCompositeOp)
    end
    @page = background.composite(photodone[0], Magick::NorthWestGravity, 0, 0, Magick::OverCompositeOp)
    @page = @page.composite(photodone[1], Magick::NorthWestGravity, 0.755*@xpx, 0, Magick::OverCompositeOp)
    @pages << @page
  end

  # 15_Макет
  def merge_pagetemplate_15(page)
    background = Magick::Image.new(@xpx, @ypx) { self.background_color = page.bgcolor }
    framewidth    = 0.245*@xpx
    frameheight   = @ypx
    photodone     = []
    (0..1).each do |i|
      if i > 0
        framewidth    = 0.75*@xpx
        frameheight   = @ypx
      end
      photo         = Image.read([page.images[i].path][0])[0]
      move          = translation(page, photo, framewidth, frameheight, i)
      photo         = resize_to_fill(photo, framewidth, frameheight)
      photodone[i]     = Magick::Image.new(framewidth, frameheight)
      photodone[i].composite!(photo, move[0], move[1], Magick::OverCompositeOp)
    end
    @page = background.composite(photodone[0], Magick::NorthWestGravity, 0, 0, Magick::OverCompositeOp)
    @page = @page.composite(photodone[1], Magick::NorthWestGravity, 0.25*@xpx, 0, Magick::OverCompositeOp)
    @pages << @page
  end

  # Склеиваем страницы
  def merge_2_page(pages)
    background = Magick::Image.new(@xpx, @ypx)
    razvorot   = background.composite(pages[0], Magick::NorthWestGravity, 0, 0, Magick::OverCompositeOp)
    if pages.count > 1
      razvorot   = razvorot.composite(pages[1], Magick::NorthEastGravity, 0, 0, Magick::OverCompositeOp)
    end
    razvorot.units = Magick::PixelsPerInchResolution
    razvorot.density = "300x300"
    directory_name = "public/orders/" + @order.name
    Dir.mkdir(directory_name) unless File.exists?(directory_name)
    if @rzvrtnum < 10
      razvorot.write(directory_name + "/0" + @rzvrtnum.to_s + ".jpg")
    else
      razvorot.write(directory_name + "/" + @rzvrtnum.to_s + ".jpg")
    end
    ziporder(directory_name)
  end

  # Архивируем заказ
  def ziporder(path)
    require 'zip'
    path.sub!(%r[/$],'')
    archive = File.join("public/orders/",File.basename(path))+'.zip'
    FileUtils.rm archive, :force=>true

    Zip::File.open(archive, 'w') do |zipfile|
      Dir["#{path}/**/**"].reject{|f|f==archive}.each do |file|
        zipfile.add(file.sub(path+'/',''),file)
      end
    end
  end
end
