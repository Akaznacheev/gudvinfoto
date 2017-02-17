module BookmakeHelper
  include Magick

  # Выбираем макет
  def template_choose(page)
    send(:"merge_pagetemplate_#{page.template}", page)
  end

  #Заполнение фрейма изображением
  def resize_to_fill(photo, fw, fh)
    if fw/fh.to_f > photo.columns/photo.rows.to_f
      photo.resize_to_fill!( fw , photo.rows*fw/photo.columns)
    else
      photo.resize_to_fill!( photo.columns*fh/photo.rows , fh)
    end
  end

  #Сдвиг изображения внутри фрейма
  def translation(page, photo, fw, fh, i)
    movex         = (-page.positions[i].split('%')[0].to_f)*(fh*photo.columns-fw*photo.rows)/(100*photo.rows)
    movey         = (-page.positions[i].split('%')[1].to_f)*(fw*photo.rows-fh*photo.columns)/(100*photo.columns)
    return [movex, movey]
  end

  # Чтение фото, Заполнение фрейма изображением и сдвиг изображения внутри фрейма
  def resize_and_move(page,i, framewidth, frameheight, photodone)
    photo = Image.read("public/"+page.images[i])[0]
    move = translation(page, photo, framewidth, frameheight, i)
    photo = resize_to_fill(photo, framewidth, frameheight)
    photodone[i] = Magick::Image.new(framewidth, frameheight)
    photodone[i].composite!(photo, move[0], move[1], Magick::OverCompositeOp)
    clear_mem([photo], [move])
    return photodone[i]
  end

  # Задник
  def backside_cover(page, framewidth, frameheight)
    backsidecover   = Magick::Image.new(framewidth, frameheight) { self.background_color = page.bgcolor }
    logo            = Image.read("app/assets/images/backsidelogo.png")[0]
    case
      when page.book.bookprice.format == "10см*10см"
        logo = logo.resize_to_fill!( logo.columns/2 , logo.rows/2)
      when page.book.bookprice.format == "15см*15см"
        logo = logo.resize_to_fill!( logo.columns*3/4 , logo.rows*3/4)
    end
    backsidecover.composite!(logo, Magick::CenterGravity, 0, 0.25*frameheight, Magick::OverCompositeOp)
  end

  # Отстав
  def otstav(page, coverypx, otstavheight)
    texttopaste = page.book.name.tr("\n"," ")
    otstav = Magick::Image.new(coverypx, otstavheight) { self.background_color = page.bgcolor }
    text = Magick::Draw.new
    text.font = "public/assets/fonts/" + page.book.fontfamily + ".ttf"
    text.pointsize = 0.6 * otstav.rows
    text.gravity = Magick::CenterGravity
    text.fill = page.book.fontcolor
    text.annotate(otstav, 0,0,0,0, texttopaste)
    return otstav
  end

  #Пробуем очищать память
  def clear_mem(images,variables)
    images.each do |image|
      image.destroy!
    end
    variables.each do |var|
      var = nil
    end
  end

  # 1_макет обложки
  def frontcover_1(page, framewidth, frameheight)
    photo             = Image.read("public/"+page.images.first)[0]
    imageframewidth   = 0.6*framewidth
    imageframeheight  = 0.6*frameheight
    textframewidth    = framewidth
    textframeheight   = 0.3*frameheight
    photodone         = []
    imageframe        = resize_and_move(page, 0, imageframewidth, imageframeheight, photodone)

    @text = page.book.name
    textframe = Magick::Image.new(textframewidth, textframeheight) { self.background_color = page.bgcolor }
    text = Magick::Draw.new
    text.font = "public/assets/fonts/" + page.book.fontfamily + ".ttf"
    text.pointsize = page.book.fontsize.to_i * 0.01 * frameheight * 2
    text.gravity = Magick::CenterGravity
    text.fill = page.book.fontcolor
    text.annotate(textframe, 0,0,0,0, @text)

    frontcover = Magick::Image.new(framewidth, frameheight) { self.background_color = page.bgcolor }
    frontcover.composite!(imageframe, Magick::NorthWestGravity, 0.2*framewidth, 0.1*frameheight, Magick::OverCompositeOp)
    frontcover.composite!(textframe, Magick::NorthWestGravity, 0, imageframeheight+0.1*frameheight, Magick::OverCompositeOp)
    clear_mem([photo, imageframe, textframe], [imageframewidth,imageframeheight,textframewidth,textframeheight,@text])
    return frontcover
  end

  # 2_макет обложки
  def frontcover_2(page, framewidth, frameheight)
    textframewidth    = 0.45*framewidth
    textframeheight   = 0.45*frameheight
    photodone         = []

    @text = page.book.name
    textframe = Magick::Image.new(textframewidth, textframeheight) { self.background_color = page.bgcolor }
    text = Magick::Draw.new
    text.font = "public/assets/fonts/" + page.book.fontfamily + ".ttf"
    text.pointsize = page.book.fontsize.to_i * 0.01 * frameheight * 2
    text.gravity = Magick::CenterGravity
    text.fill = page.book.fontcolor
    text.annotate(textframe, 0,0,0,0, @text)

    frontcover = Magick::Image.new(framewidth, frameheight) { self.background_color = page.bgcolor }
    if page.images.present?
      imageframewidth   = 0.45*framewidth
      imageframeheight  = 0.45*frameheight
      photo             = Image.read("public/"+page.images.first)[0]
      imageframe        = resize_and_move(page, 0, imageframewidth, imageframeheight, photodone)
      frontcover.composite!(imageframe, Magick::NorthWestGravity, 0.05*framewidth, 0.275*frameheight, Magick::OverCompositeOp)
    end
    frontcover.composite!(textframe, Magick::NorthWestGravity, 0.5*framewidth, 0.275*frameheight, Magick::OverCompositeOp)
    clear_mem([photo, imageframe, textframe], [imageframewidth,imageframeheight,textframewidth,textframeheight,@text])
    return frontcover
  end

  # 3_макет обложки
  def frontcover_3(page, framewidth, frameheight)
    photo         = Image.read("public/"+page.images.first)[0]
    imageframewidth   = framewidth
    imageframeheight  = 0.7*frameheight
    textframewidth    = framewidth
    textframeheight   = 0.3*frameheight
    photodone         = []
    imageframe        = resize_and_move(page, 0, imageframewidth, imageframeheight, photodone)

    @text = page.book.name
    textframe = Magick::Image.new(textframewidth, textframeheight) { self.background_color = page.bgcolor }
    text = Magick::Draw.new
    text.font = "public/assets/fonts/" + page.book.fontfamily + ".ttf"
    text.pointsize = page.book.fontsize.to_i * 0.01 * frameheight * 2
    text.gravity = Magick::CenterGravity
    text.fill = page.book.fontcolor
    text.annotate(textframe, 0,0,0,0, @text)

    frontcover   = Magick::Image.new(framewidth, frameheight) { self.background_color = page.bgcolor }
    frontcover.composite!(imageframe, Magick::NorthWestGravity, 0, 0, Magick::OverCompositeOp)
    frontcover.composite!(textframe, Magick::NorthWestGravity, 0, imageframeheight, Magick::OverCompositeOp)
    clear_mem([photo, imageframe, textframe], [imageframewidth,imageframeheight,textframewidth,textframeheight,@text])
    return frontcover
  end

  # 4_макет обложки
  def frontcover_4(page, framewidth, frameheight)
    photo         = Image.read("public/"+page.images.first)[0]
    imageframewidth   = 0.45*framewidth
    imageframeheight  = 0.9*frameheight
    textframewidth    = 0.45*framewidth
    textframeheight   = 0.45*frameheight
    photodone         = []
    imageframe        = resize_and_move(page, 0, imageframewidth, imageframeheight, photodone)

    @text = page.book.name
    textframe = Magick::Image.new(textframewidth, textframeheight) { self.background_color = page.bgcolor }
    text = Magick::Draw.new
    text.font = "public/assets/fonts/" + page.book.fontfamily + ".ttf"
    text.pointsize = page.book.fontsize.to_i * 0.01 * frameheight * 2
    text.gravity = Magick::CenterGravity
    text.fill = page.book.fontcolor
    text.annotate(textframe, 0,0,0,0, @text)

    frontcover = Magick::Image.new(framewidth, frameheight) { self.background_color = page.bgcolor }
    frontcover.composite!(imageframe, Magick::NorthWestGravity, 0.05*framewidth, 0.05*frameheight, Magick::OverCompositeOp)
    frontcover.composite!(textframe, Magick::NorthWestGravity, 0.5*framewidth, 0.275*frameheight, Magick::OverCompositeOp)
    clear_mem([photo, imageframe, textframe], [imageframewidth,imageframeheight,textframewidth,textframeheight,@text])
    return frontcover
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
    clear_mem([], [@text])
    return frontcover
  end

  # 6_макет обложки
  def frontcover_6(page, framewidth, frameheight)
    imageframewidth   = 0.2235*framewidth
    imageframeheight  = 0.2235*frameheight
    textframewidth    = 0.447*framewidth+framewidth/500
    textframeheight   = 0.2235*frameheight

    @text = page.book.name
    textframe = Magick::Image.new(textframewidth, textframeheight) { self.background_color = page.bgcolor }
    text = Magick::Draw.new
    text.font = "public/assets/fonts/" + page.book.fontfamily + ".ttf"
    text.pointsize = page.book.fontsize.to_i * 0.01 * frameheight * 2
    text.gravity = Magick::CenterGravity
    text.fill = page.book.fontcolor
    text.annotate(textframe, 0,0,0,0, @text)

    frontcover = Magick::Image.new(framewidth, frameheight) { self.background_color = page.bgcolor }
    photodone         = []
    (0..13).each do |i|
      resize_and_move(page, i, imageframewidth, imageframeheight, photodone)
    end

    frontcover.composite!(photodone[0], Magick::NorthWestGravity, framewidth/20, frameheight/20, Magick::OverCompositeOp)
    frontcover.composite!(photodone[1], Magick::NorthWestGravity, framewidth/20+imageframewidth+framewidth/500, frameheight/20, Magick::OverCompositeOp)
    frontcover.composite!(photodone[2], Magick::NorthWestGravity, framewidth/20+2*imageframewidth+2*framewidth/500, frameheight/20, Magick::OverCompositeOp)
    frontcover.composite!(photodone[3], Magick::NorthWestGravity, framewidth/20+3*imageframewidth+3*framewidth/500, frameheight/20, Magick::OverCompositeOp)
    frontcover.composite!(photodone[4], Magick::NorthWestGravity, framewidth/20, frameheight/20+imageframeheight+frameheight/500, Magick::OverCompositeOp)
    frontcover.composite!(photodone[5], Magick::NorthWestGravity, framewidth/20+imageframewidth+framewidth/500, frameheight/20+imageframeheight+frameheight/500, Magick::OverCompositeOp)
    frontcover.composite!(photodone[6], Magick::NorthWestGravity, framewidth/20+2*imageframewidth+2*framewidth/500, frameheight/20+imageframeheight+frameheight/500, Magick::OverCompositeOp)
    frontcover.composite!(photodone[7], Magick::NorthWestGravity, framewidth/20+3*imageframewidth+3*framewidth/500, frameheight/20+imageframeheight+frameheight/500, Magick::OverCompositeOp)
    frontcover.composite!(photodone[8], Magick::NorthWestGravity, framewidth/20, frameheight/20+2*imageframeheight+2*frameheight/500, Magick::OverCompositeOp)
    frontcover.composite!(photodone[9], Magick::NorthWestGravity, framewidth/20+imageframewidth+framewidth/500, frameheight/20+2*imageframeheight+2*frameheight/500, Magick::OverCompositeOp)
    frontcover.composite!(textframe, Magick::NorthWestGravity, framewidth/20+2*imageframewidth+2*framewidth/500, frameheight/20+2*imageframeheight+2*frameheight/500, Magick::OverCompositeOp)
    frontcover.composite!(photodone[10], Magick::NorthWestGravity, framewidth/20, frameheight/20+3*imageframeheight+3*framewidth/500, Magick::OverCompositeOp)
    frontcover.composite!(photodone[11], Magick::NorthWestGravity, framewidth/20+imageframewidth+framewidth/500, frameheight/20+3*imageframeheight+3*frameheight/500, Magick::OverCompositeOp)
    frontcover.composite!(photodone[12], Magick::NorthWestGravity, framewidth/20+2*imageframewidth+2*framewidth/500, frameheight/20+3*imageframeheight+3*frameheight/500, Magick::OverCompositeOp)
    frontcover.composite!(photodone[13], Magick::NorthWestGravity, framewidth/20+3*imageframewidth+3*framewidth/500, frameheight/20+3*imageframeheight+3*frameheight/500, Magick::OverCompositeOp)
    clear_mem([textframe], [imageframewidth,imageframeheight,textframewidth,textframeheight,@text])
    return frontcover
  end

  # сборка обложки
  def cover_create(page)
    coverypx = page.book.bookprice.coverheight
    coverxpx = page.book.bookprice.coverwidth + ((page.book.bookpages.count-1)/2-10)*11.811
    klapan = 15*11.811
    otstavheight = 11.811 * (page.book.bookpages.count-1)/2
    framewidth    = (coverxpx-2*klapan-otstavheight)/2
    frameheight   = coverypx-2*klapan

    frontcover = send(:"frontcover_#{page.template}", page, framewidth, frameheight)
    otstav = otstav(page, coverypx, otstavheight)
    backsidecover = backside_cover(page, framewidth, frameheight)

    cover = Magick::Image.new(coverxpx, coverypx ){ self.background_color = page.bgcolor }
    cover.composite!(backsidecover, Magick::NorthWestGravity, klapan, klapan, Magick::OverCompositeOp)
    cover.composite!(otstav.rotate(-90), Magick::NorthWestGravity, framewidth+klapan, 0, Magick::OverCompositeOp)
    cover.composite!(frontcover, Magick::NorthWestGravity, framewidth+klapan+otstavheight, klapan, Magick::OverCompositeOp)
    text = Magick::Draw.new
    if page.bgcolor == "white"
      text.stroke('Black')
    else
      text.stroke('White')
    end
    text.stroke_width(6)
    text.line(framewidth+klapan+otstavheight-3, 0, framewidth+klapan+otstavheight-3, 75)
    text.line(framewidth+klapan+otstavheight-40, 75, framewidth+klapan+otstavheight+34, 75)
    text.line(framewidth+klapan+otstavheight-3, coverypx-75, framewidth+klapan+otstavheight-3, coverypx)
    text.draw(cover)
    cover.units = Magick::PixelsPerInchResolution
    cover.density = "300x300"
    write_to_dir(page.book.order.name, cover, 0)
    clear_mem([frontcover,otstav,backsidecover,cover], [page,coverxpx,coverypx,klapan,otstavheight,framewidth,frameheight])
  end

  # 1_Макет фото на всю страницу
  def merge_pagetemplate_1(page)
    framewidth    = @xpx/2
    frameheight   = @ypx
    photodone     = []
    resize_and_move(page, 0, framewidth, frameheight, photodone)
    clear_mem([], [page,framewidth,frameheight])
    return photodone[0]
  end

  # 2_Макет фото по середине
  def merge_pagetemplate_2(page)
    bookpage = Magick::Image.new(@xpx/2, @ypx) { self.background_color = page.bgcolor }
    framewidth    = 4*@xpx/10
    frameheight   = 4*@ypx/5
    photodone     = []
    resize_and_move(page, 0, framewidth, frameheight, photodone)
    bookpage.composite!(photodone[0], Magick::NorthWestGravity, @ypx/10, @ypx/10, Magick::OverCompositeOp)
    clear_mem([], [page,framewidth,frameheight])
    return bookpage
  end

  # 3_Макет фото по середине
  def merge_pagetemplate_3(page)
    bookpage = Magick::Image.new(@xpx/2, @ypx) { self.background_color = page.bgcolor }
    framewidth    = 3*@xpx/10
    frameheight   = 3*@ypx/5
    photodone     = []
    resize_and_move(page, 0, framewidth, frameheight, photodone)
    bookpage.composite!(photodone[0], Magick::NorthWestGravity, @ypx/5, @ypx/5, Magick::OverCompositeOp)
    clear_mem([], [page,framewidth,frameheight])
    return bookpage
  end

  # 4_Макет
  def merge_pagetemplate_4(page)
    bookpage = Magick::Image.new(@xpx/2, @ypx) { self.background_color = page.bgcolor }
    framewidth    = 0.33*(4*@xpx/10)
    frameheight   = 0.33*(4*@ypx/5)
    photodone     = []
    (0..8).each do |i|
      resize_and_move(page, i, framewidth, frameheight, photodone)
    end
    bookpage.composite!(photodone[0], Magick::NorthWestGravity, @ypx/10, @ypx/10, Magick::OverCompositeOp)
    bookpage.composite!(photodone[1], Magick::NorthWestGravity, 0.335*(4*@ypx/5)+@ypx/10, @ypx/10, Magick::OverCompositeOp)
    bookpage.composite!(photodone[2], Magick::NorthWestGravity, 0.67*(4*@ypx/5)+@ypx/10, @ypx/10, Magick::OverCompositeOp)
    bookpage.composite!(photodone[3], Magick::NorthWestGravity, @ypx/10, 0.335*(4*@ypx/5)+@ypx/10, Magick::OverCompositeOp)
    bookpage.composite!(photodone[4], Magick::NorthWestGravity, 0.335*(4*@ypx/5)+@ypx/10, 0.335*(4*@ypx/5)+@ypx/10, Magick::OverCompositeOp)
    bookpage.composite!(photodone[5], Magick::NorthWestGravity, 0.67*(4*@ypx/5)+@ypx/10, 0.335*(4*@ypx/5)+@ypx/10, Magick::OverCompositeOp)
    bookpage.composite!(photodone[6], Magick::NorthWestGravity, @ypx/10, 0.67*(4*@ypx/5)+@ypx/10, Magick::OverCompositeOp)
    bookpage.composite!(photodone[7], Magick::NorthWestGravity, 0.335*(4*@ypx/5)+@ypx/10, 0.67*(4*@ypx/5)+@ypx/10, Magick::OverCompositeOp)
    bookpage.composite!(photodone[8], Magick::NorthWestGravity, 0.67*(4*@ypx/5)+@ypx/10, 0.67*(4*@ypx/5)+@ypx/10, Magick::OverCompositeOp)
    clear_mem([], [page,framewidth,frameheight])
    return bookpage
  end

  # 5_Макет
  def merge_pagetemplate_5(page)
    bookpage = Magick::Image.new(@xpx/2, @ypx) { self.background_color = page.bgcolor }
    framewidth    = 0.495*(9*@xpx/20)
    frameheight   = 0.33*(9*@ypx/10)
    photodone     = []
    (0..3).each do |i|
      if i > 2
        framewidth    = 0.495*(9*@xpx/20)
        frameheight   = 9*@ypx/10
      end
      resize_and_move(page, i, framewidth, frameheight, photodone)
    end
    bookpage.composite!(photodone[0], Magick::NorthWestGravity, @ypx/20, @ypx/20, Magick::OverCompositeOp)
    bookpage.composite!(photodone[1], Magick::NorthWestGravity, @ypx/20, 0.335*(9*@ypx/10)+@ypx/20, Magick::OverCompositeOp)
    bookpage.composite!(photodone[2], Magick::NorthWestGravity, @ypx/20, 0.67*(9*@ypx/10)+@ypx/20, Magick::OverCompositeOp)
    bookpage.composite!(photodone[3], Magick::NorthEastGravity, @ypx/20, @ypx/20, Magick::OverCompositeOp)
    clear_mem([], [page,framewidth,frameheight])
    return bookpage
  end

  # 6_Макет
  def merge_pagetemplate_6(page)
    bookpage = Magick::Image.new(@xpx/2, @ypx) { self.background_color = page.bgcolor }
    framewidth    = 3*@xpx/10
    frameheight   = @ypx
    photodone     = []
    resize_and_move(page, 0, framewidth, frameheight, photodone)
    bookpage.composite!(photodone[0], Magick::NorthWestGravity, @ypx/5, 0, Magick::OverCompositeOp)
    clear_mem([], [page,framewidth,frameheight])
    return bookpage
  end

  # 7_Макет
  def merge_pagetemplate_7(page)
    bookpage = Magick::Image.new(@xpx/2, @ypx) { self.background_color = page.bgcolor }
    framewidth    = @xpx/2
    frameheight   = 3*@ypx/5
    photodone     = []
    resize_and_move(page, 0, framewidth, frameheight, photodone)
    bookpage.composite!(photodone[0], Magick::NorthWestGravity, 0, @ypx/5, Magick::OverCompositeOp)
    clear_mem([], [page,framewidth,frameheight])
    return bookpage
  end

  # 8_Макет
  def merge_pagetemplate_8(page)
    bookpage = Magick::Image.new(@xpx/2, @ypx) { self.background_color = page.bgcolor }
    framewidth    = 0.495*@xpx/2
    frameheight   = 0.495*(3*@ypx/5)
    photodone     = []
    (0..3).each do |i|
      resize_and_move(page, i, framewidth, frameheight, photodone)
    end
    if (page.pagenum % 2) == 1
      bookpage.composite!(photodone[0], Magick::NorthWestGravity, 0, @ypx/5, Magick::OverCompositeOp)
      bookpage.composite!(photodone[1], Magick::NorthWestGravity, 0.5*@ypx, @ypx/5, Magick::OverCompositeOp)
      bookpage.composite!(photodone[2], Magick::NorthWestGravity, 0, 0.505*(3*@ypx/5)+@ypx/5, Magick::OverCompositeOp)
      bookpage.composite!(photodone[3], Magick::NorthWestGravity, 0.5*@ypx, 0.505*(3*@ypx/5)+@ypx/5, Magick::OverCompositeOp)
    else
      bookpage.composite!(photodone[0], Magick::NorthEastGravity, 0, @ypx/5, Magick::OverCompositeOp)
      bookpage.composite!(photodone[1], Magick::NorthEastGravity, 0.5*@ypx, @ypx/5, Magick::OverCompositeOp)
      bookpage.composite!(photodone[2], Magick::NorthEastGravity, 0, 0.505*(3*@ypx/5)+@ypx/5, Magick::OverCompositeOp)
      bookpage.composite!(photodone[3], Magick::NorthEastGravity, 0.5*@ypx, 0.505*(3*@ypx/5)+@ypx/5, Magick::OverCompositeOp)
    end
    clear_mem([], [page,framewidth,frameheight])
    return bookpage
  end

  # 11_Макет
  def merge_pagetemplate_11(page)
    bookpage = Magick::Image.new(@xpx, @ypx) { self.background_color = page.bgcolor }
    framewidth    = @xpx
    frameheight   = @ypx
    photodone     = []
    resize_and_move(page, 0, framewidth, frameheight, photodone)
    bookpage.composite!(photodone[0], Magick::NorthWestGravity, 0, 0, Magick::OverCompositeOp)
    clear_mem([], [page,framewidth,frameheight])
    return bookpage
  end

  # 12_Макет
  def merge_pagetemplate_12(page)
    bookpage = Magick::Image.new(@xpx, @ypx) { self.background_color = page.bgcolor }
    framewidth    = 0.75*@xpx
    frameheight   = @ypx
    photodone     = []
    (0..3).each do |i|
      if i > 0
        framewidth    = 0.25*(9*@xpx/10)
        frameheight   = 0.33*9*@ypx/10
      end
      resize_and_move(page, i, framewidth, frameheight, photodone)
    end
    bookpage.composite!(photodone[0], Magick::NorthWestGravity, 0, 0, Magick::OverCompositeOp)
    bookpage.composite!(photodone[1], Magick::NorthEastGravity, @ypx/40, @ypx/40, Magick::OverCompositeOp)
    bookpage.composite!(photodone[2], Magick::NorthEastGravity, @ypx/40, 0.335*(9*@ypx/10)+2*@ypx/40, Magick::OverCompositeOp)
    bookpage.composite!(photodone[3], Magick::NorthEastGravity, @ypx/40, 0.67*(9*@ypx/10)+3*@ypx/40, Magick::OverCompositeOp)
    clear_mem([], [page,framewidth,frameheight])
    return bookpage
  end

  # 13_Макет
  def merge_pagetemplate_13(page)
    bookpage = Magick::Image.new(@xpx, @ypx) { self.background_color = page.bgcolor }
    framewidth    = 0.25*(9*@xpx/10)
    frameheight   = 0.33*9*@ypx/10
    photodone     = []
    (0..3).each do |i|
      if i > 2
        framewidth    = 0.75*@xpx
        frameheight   = @ypx
      end
      resize_and_move(page, i, framewidth, frameheight, photodone)
    end
    bookpage.composite!(photodone[0], Magick::NorthWestGravity, @ypx/40, @ypx/40, Magick::OverCompositeOp)
    bookpage.composite!(photodone[1], Magick::NorthWestGravity, @ypx/40, 0.335*(9*@ypx/10)+2*@ypx/40, Magick::OverCompositeOp)
    bookpage.composite!(photodone[2], Magick::NorthWestGravity, @ypx/40, 0.67*(9*@ypx/10)+3*@ypx/40, Magick::OverCompositeOp)
    bookpage.composite!(photodone[3], Magick::NorthEastGravity, 0, 0, Magick::OverCompositeOp)
    clear_mem([], [page,framewidth,frameheight])
    return bookpage
  end

  # 14_Макет
  def merge_pagetemplate_14(page)
    bookpage = Magick::Image.new(@xpx, @ypx) { self.background_color = page.bgcolor }
    framewidth    = 0.75*@xpx
    frameheight   = @ypx
    photodone     = []
    (0..1).each do |i|
      if i > 0
        framewidth    = 0.245*@xpx
        frameheight   = @ypx
      end
      resize_and_move(page, i, framewidth, frameheight, photodone)
    end
    bookpage.composite!(photodone[0], Magick::NorthWestGravity, 0, 0, Magick::OverCompositeOp)
    bookpage.composite!(photodone[1], Magick::NorthEastGravity, 0, 0, Magick::OverCompositeOp)
    clear_mem([], [page,framewidth,frameheight])
    return bookpage
  end

  # 15_Макет
  def merge_pagetemplate_15(page)
    bookpage = Magick::Image.new(@xpx, @ypx) { self.background_color = page.bgcolor }
    framewidth    = 0.245*@xpx
    frameheight   = @ypx
    photodone     = []
    (0..1).each do |i|
      if i > 0
        framewidth    = 0.75*@xpx
        frameheight   = @ypx
      end
      resize_and_move(page, i, framewidth, frameheight, photodone)
    end
    bookpage.composite!(photodone[0], Magick::NorthWestGravity, 0, 0, Magick::OverCompositeOp)
    bookpage.composite!(photodone[1], Magick::NorthEastGravity, 0, 0, Magick::OverCompositeOp)
    clear_mem([], [page,framewidth,frameheight])
    return bookpage
  end

  # Склеиваем страницы
  def merge_2_page(ordername, razvorotpages)
    pages = []
    razvorotpages.each_with_index do |bpage,i|
      if bpage.images.present?
        pages[i] = template_choose(bpage)
      end
    end
    if pages.any?
      razvorot = Magick::Image.new(@xpx, @ypx)
      if pages[0].present?
        razvorot.composite!(pages[0], Magick::NorthWestGravity, 0, 0, Magick::OverCompositeOp)
      end
      if pages[1].present?
        razvorot.composite!(pages[1], Magick::NorthEastGravity, 0, 0, Magick::OverCompositeOp)
      end
      razvorot.units = Magick::PixelsPerInchResolution
      razvorot.density = "300x300"
      rzvrtnum = razvorotpages.last.pagenum / 2
      write_to_dir(ordername, razvorot, rzvrtnum)
      pages.clear
      clear_mem([razvorot], [ordername,razvorotpages,rzvrtnum])
    end
  end

  #Запись в папку
  def write_to_dir(ordername, file, rzvrtnum)
    path = "public/orders/" + ordername
    Dir.mkdir(path) unless File.exists?(path)
    case
      when rzvrtnum < 10
        filename = "0" + rzvrtnum.to_s + ".jpg"
      else
        filename = rzvrtnum.to_s + ".jpg"
    end
    file.write(path + "/" + filename)
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
    FileUtils.rm_rf(path)
  end
end