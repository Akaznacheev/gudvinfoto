module BookmakeHelper
  include Magick
  # Choosing template
  def template_choose(page)
    send(:"merge_page_template_#{page.template}", page)
  end

  # Putting image into frame
  def resize_to_fill(photo, fw, fh)
    parameters = if fw / fh.to_f > photo.columns / photo.rows.to_f
                   [fw, photo.rows * fw / photo.columns]
                 else
                   [photo.columns * fh / photo.rows, fh]
                 end
    photo.resize_to_fill!(*parameters)
  end

  # Moving image in frame
  def translation(page, photo, fw, fh, i)
    move_x = (- page.positions[i].split('%')[0].to_f) * (fh * photo.columns - fw * photo.rows) / (100 * photo.rows)
    move_y = (- page.positions[i].split('%')[1].to_f) * (fw * photo.rows - fh * photo.columns) / (100 * photo.columns)
    [move_x, move_y]
  end

  # Reading photo, insert it into frame and move it in
  def resize_and_move(page, i, frame_width, frame_height, photodone)
    photo = Image.read(URI.decode('public' + page.images[i]))[0]
    move = translation(page, photo, frame_width, frame_height, i)
    photo = resize_to_fill(photo, frame_width, frame_height)
    photodone[i] = Image.new(frame_width, frame_height)
    photodone[i].composite!(photo, move[0], move[1], OverCompositeOp)
    clear_mem([photo], [move])
    photodone[i]
  end

  # Cover back_side
  def backside_cover(page, frame_width, frame_height)
    back_side_cover = Image.new(frame_width, frame_height) { self.background_color = page.bgcolor }
    logo = page.bgcolor == 'white' ? 'back_side_logo_black.png' : 'back_side_logo_white.png'
    logo = Image.read('app/assets/images/' + logo)[0]
    logo = logo.resize_to_fit!(11.811 * 50, 11.811 * 50)
    back_side_cover.composite!(logo, CenterGravity, 0, 0.25 * frame_height, OverCompositeOp)
  end

  # Otstav
  def otstav(page, coverypx, otstavheight)
    otstav = Image.new(coverypx, otstavheight) { self.background_color = page.bgcolor }
    if page.template != 1
      text_to_paste = page.book.name.gsub(/(?:\n\r?|\r\n?)/, ' ')
      text = Draw.new
      text.font = 'public/assets/fonts/' + page.book.fontfamily + '.ttf'
      text.pointsize = 0.6 * otstav.rows
      text.gravity = CenterGravity
      text.fill = page.book.fontcolor
      text.annotate(otstav, 0, 0, 0, 0, text_to_paste)
    end
    otstav
  end

  # Clear variables
  def clear_mem(images, variables)
    images.each(&:destroy!)
    variables.each do |_var|
      _var = nil
    end
  end

  # Cover template 1
  def frontcover_1(page, frame_width, frame_height)
    photo = Image.read(URI.decode('public' + page.images.first))[0]
    image_frame_width   = frame_width
    image_frame_height  = frame_height
    photo_done         = []
    image_frame        = resize_and_move(page, 0,
                                         image_frame_width,
                                         image_frame_height,
                                         photo_done)
    frontcover = Image.new(frame_width, frame_height) { self.background_color = page.bgcolor }
    frontcover.composite!(image_frame, NorthWestGravity, 0, 0, OverCompositeOp)
    clear_mem([photo, image_frame],
              [image_frame_width, image_frame_height])
    frontcover
  end

  # Cover template 2
  def frontcover_2(page, frame_width, frame_height)
    photo = Image.read(URI.decode('public' + page.images.first))[0]
    image_frame_width = 0.6 * frame_width
    image_frame_height = 0.6 * frame_height
    text_frame_width = frame_width
    text_frame_height = 0.3 * frame_height
    photodone = []
    image_frame = resize_and_move(page, 0,
                                  image_frame_width,
                                  image_frame_height,
                                  photodone)
    text = page.book.name
    text_line = fit_text(page, text, text_frame_width, frame_height)
    text_frame = Image.new(text_frame_width, text_frame_height) { self.background_color = page.bgcolor }
    text = Draw.new
    text.font = 'public/assets/fonts/' + page.book.fontfamily + '.ttf'
    text.pointsize = page.book.fontsize.to_i * 0.01 * frame_height * 2
    text.gravity = CenterGravity
    text.fill = page.book.fontcolor
    text.annotate(text_frame, 0, 0, 0, 0, text_line)

    frontcover = Image.new(frame_width, frame_height) { self.background_color = page.bgcolor }
    frontcover.composite!(image_frame, NorthWestGravity, 0.2 * frame_width, 0.1 * frame_height, OverCompositeOp)
    frontcover.composite!(text_frame, NorthWestGravity, 0, image_frame_height + 0.1 * frame_height, OverCompositeOp)
    clear_mem([photo, image_frame, text_frame],
              [image_frame_width, image_frame_height, text_frame_width, text_frame_height, text])
    frontcover
  end

  # Cover template 3
  def frontcover_3(page, framewidth, frameheight)
    textframewidth    = 0.5 * framewidth
    textframeheight   = 0.5 * frameheight
    photodone         = []

    text = page.book.name
    text_line = fit_text(page, text, textframewidth, frameheight)
    textframe = Image.new(textframewidth, textframeheight) { self.background_color = page.bgcolor }
    text = Draw.new
    text.font = 'public/assets/fonts/' + page.book.fontfamily + '.ttf'
    text.pointsize = page.book.fontsize.to_i * 0.01 * frameheight * 2
    text.gravity = CenterGravity
    text.fill = page.book.fontcolor
    text.annotate(textframe, 0, 0, 0, 0, text_line)

    frontcover = Image.new(framewidth, frameheight) { self.background_color = page.bgcolor }
    if page.images.present?
      imageframewidth   = 0.45 * framewidth
      imageframeheight  = 0.45 * frameheight
      photo             = Image.read(URI.decode('public' + page.images.first))[0]
      imageframe        = resize_and_move(page, 0, imageframewidth, imageframeheight, photodone)
      frontcover.composite!(imageframe, NorthWestGravity, 0.05 * framewidth, 0.275 * frameheight, OverCompositeOp)
    end
    frontcover.composite!(textframe, NorthWestGravity, 0.5 * framewidth, 0.25 * frameheight, OverCompositeOp)
    clear_mem([photo, imageframe, textframe],
              [imageframewidth, imageframeheight, textframewidth, textframeheight, text])
    frontcover
  end

  # Cover template 4
  def frontcover_4(page, framewidth, frameheight)
    photo = Image.read(URI.decode('public' + page.images.first))[0]
    imageframewidth   = framewidth
    imageframeheight  = 0.7 * frameheight
    textframewidth    = framewidth
    textframeheight   = 0.3 * frameheight
    photodone         = []
    imageframe        = resize_and_move(page, 0, imageframewidth, imageframeheight, photodone)

    text = page.book.name
    text_line = fit_text(page, text, textframewidth, frameheight)
    textframe = Image.new(textframewidth, textframeheight) { self.background_color = page.bgcolor }
    text = Draw.new
    text.font = 'public/assets/fonts/' + page.book.fontfamily + '.ttf'
    text.pointsize = page.book.fontsize.to_i * 0.01 * frameheight * 2
    text.gravity = CenterGravity
    text.fill = page.book.fontcolor
    text.annotate(textframe, 0, 0, 0, 0, text_line)

    frontcover = Image.new(framewidth, frameheight) { self.background_color = page.bgcolor }
    frontcover.composite!(imageframe, NorthWestGravity, 0, 0, OverCompositeOp)
    frontcover.composite!(textframe, NorthWestGravity, 0, imageframeheight, OverCompositeOp)
    clear_mem([photo, imageframe, textframe],
              [imageframewidth, imageframeheight, textframewidth, textframeheight, text])
    frontcover
  end

  # Cover template 5
  def frontcover_5(page, framewidth, frameheight)
    photo = Image.read(URI.decode('public' + page.images.first))[0]
    imageframewidth   = 0.45 * framewidth
    imageframeheight  = 0.95 * frameheight
    textframewidth    = 0.5 * framewidth
    textframeheight   = 0.5 * frameheight
    photodone         = []
    imageframe        = resize_and_move(page, 0, imageframewidth, imageframeheight, photodone)

    text = page.book.name
    text_line = fit_text(page, text, textframewidth, frameheight)
    textframe = Image.new(textframewidth, textframeheight) { self.background_color = page.bgcolor }
    text = Draw.new
    text.font = 'public/assets/fonts/' + page.book.fontfamily + '.ttf'
    text.pointsize = page.book.fontsize.to_i * 0.01 * frameheight * 2
    text.gravity = CenterGravity
    text.fill = page.book.fontcolor
    text.annotate(textframe, 0, 0, 0, 0, text_line)

    frontcover = Image.new(framewidth, frameheight) { self.background_color = page.bgcolor }
    frontcover.composite!(imageframe, NorthWestGravity, 0.025 * framewidth, 0.025 * frameheight, OverCompositeOp)
    frontcover.composite!(textframe, NorthWestGravity, 0.5 * framewidth, 0.25 * frameheight, OverCompositeOp)
    clear_mem([photo, imageframe, textframe],
              [imageframewidth, imageframeheight, textframewidth, textframeheight, text])
    frontcover
  end

  # Cover template 6
  def frontcover_6(page, framewidth, frameheight)
    text = page.book.name
    text_line = fit_text(page, text, framewidth, frameheight)
    frontcover = Image.new(framewidth, frameheight) { self.background_color = page.bgcolor }
    text = Draw.new
    text.font = 'public/assets/fonts/' + page.book.fontfamily + '.ttf'
    text.pointsize = page.book.fontsize.to_i * 0.01 * frameheight * 2
    text.gravity = CenterGravity
    text.fill = page.book.fontcolor
    text.annotate(frontcover, 0, 0, 0, 0, text_line)
    clear_mem([], [text])
    frontcover
  end

  # Cover template 7
  def frontcover_7(page, framewidth, frameheight)
    imageframewidth   = 0.2235 * framewidth
    imageframeheight  = 0.2235 * frameheight
    textframewidth    = 0.447 * framewidth + framewidth / 500
    textframeheight   = 0.2235 * frameheight

    text = page.book.name
    text_line = fit_text(page, text, framewidth, frameheight)
    textframe = Image.new(textframewidth, textframeheight) { self.background_color = page.bgcolor }
    text = Draw.new
    text.font = 'public/assets/fonts/' + page.book.fontfamily + '.ttf'
    text.pointsize = page.book.fontsize.to_i * 0.01 * frameheight * 2
    text.gravity = CenterGravity
    text.fill = page.book.fontcolor
    text.annotate(textframe, 0, 0, 0, 0, text_line)

    frontcover = Image.new(framewidth, frameheight) { self.background_color = page.bgcolor }
    photodone = []
    (0..13).each do |i|
      resize_and_move(page, i, imageframewidth, imageframeheight, photodone)
    end
    frontcover.composite!(photodone[0],
                          NorthWestGravity,
                          framewidth / 20, frameheight / 20,
                          OverCompositeOp)
    frontcover.composite!(photodone[1],
                          NorthWestGravity,
                          framewidth / 20 + imageframewidth + framewidth / 500, frameheight / 20,
                          OverCompositeOp)
    frontcover.composite!(photodone[2],
                          NorthWestGravity,
                          framewidth / 20 + 2 * imageframewidth + 2 * framewidth / 500, frameheight / 20,
                          OverCompositeOp)
    frontcover.composite!(photodone[3],
                          NorthWestGravity,
                          framewidth / 20 + 3 * imageframewidth + 3 * framewidth / 500, frameheight / 20,
                          OverCompositeOp)
    frontcover.composite!(photodone[4],
                          NorthWestGravity,
                          framewidth / 20, frameheight / 20 + imageframeheight + frameheight / 500,
                          OverCompositeOp)
    frontcover.composite!(photodone[5],
                          NorthWestGravity,
                          framewidth / 20 + imageframewidth + framewidth / 500,
                          frameheight / 20 + imageframeheight + frameheight / 500,
                          OverCompositeOp)
    frontcover.composite!(photodone[6],
                          NorthWestGravity,
                          framewidth / 20 + 2 * imageframewidth + 2 * framewidth / 500,
                          frameheight / 20 + imageframeheight + frameheight / 500,
                          OverCompositeOp)
    frontcover.composite!(photodone[7],
                          NorthWestGravity,
                          framewidth / 20 + 3 * imageframewidth + 3 * framewidth / 500,
                          frameheight / 20 + imageframeheight + frameheight / 500,
                          OverCompositeOp)
    frontcover.composite!(photodone[8],
                          NorthWestGravity,
                          framewidth / 20,
                          frameheight / 20 + 2 * imageframeheight + 2 * frameheight / 500,
                          OverCompositeOp)
    frontcover.composite!(photodone[9],
                          NorthWestGravity,
                          framewidth / 20 + imageframewidth + framewidth / 500,
                          frameheight / 20 + 2 * imageframeheight + 2 * frameheight / 500,
                          OverCompositeOp)
    frontcover.composite!(textframe,
                          NorthWestGravity,
                          framewidth / 20 + 2 * imageframewidth + 2 * framewidth / 500,
                          frameheight / 20 + 2 * imageframeheight + 2 * frameheight / 500,
                          OverCompositeOp)
    frontcover.composite!(photodone[10],
                          NorthWestGravity,
                          framewidth / 20, frameheight / 20 + 3 * imageframeheight + 3 * framewidth / 500,
                          OverCompositeOp)
    frontcover.composite!(photodone[11],
                          NorthWestGravity,
                          ramewidth / 20 + imageframewidth + framewidth / 500,
                          frameheight / 20 + 3 * imageframeheight + 3 * frameheight / 500,
                          OverCompositeOp)
    frontcover.composite!(photodone[12],
                          NorthWestGravity,
                          framewidth / 20 + 2 * imageframewidth + 2 * framewidth / 500,
                          frameheight / 20 + 3 * imageframeheight + 3 * frameheight / 500,
                          OverCompositeOp)
    frontcover.composite!(photodone[13],
                          NorthWestGravity,
                          framewidth / 20 + 3 * imageframewidth + 3 * framewidth / 500,
                          frameheight / 20 + 3 * imageframeheight + 3 * frameheight / 500,
                          OverCompositeOp)
    clear_mem([textframe], [imageframewidth, imageframeheight, textframewidth, textframeheight, text])
    frontcover
  end

  # Building cover
  def cover_create(page)
    coverypx = page.book.bookprice.coverheight
    coverxpx = page.book.bookprice.coverwidth + ((page.book.bookpages.count - 1) / 2 - 10) * 11.811
    klapan = if page.book.bookprice.format == '15см*15см'
               11 * 11.811
             else
               15 * 11.811
             end
    otstavheight = 11.811 * (page.book.bookpages.count - 1) / 2
    framewidth    = (coverxpx - 2 * klapan - otstavheight) / 2
    frameheight   = coverypx - 2 * klapan

    frontcover = send(:"frontcover_#{page.template}", page, framewidth, frameheight)
    otstav = otstav(page, coverypx, otstavheight)
    backsidecover = backside_cover(page, framewidth, frameheight)

    cover = Image.new(coverxpx, coverypx) { self.background_color = page.bgcolor }
    cover.composite!(backsidecover, NorthWestGravity, klapan, klapan, OverCompositeOp)
    cover.composite!(otstav.rotate(-90), NorthWestGravity, framewidth + klapan, 0, OverCompositeOp)
    cover.composite!(frontcover, NorthWestGravity, framewidth + klapan + otstavheight, klapan, OverCompositeOp)
    text = Draw.new
    if page.bgcolor == 'white'
      text.stroke('Black')
    else
      text.stroke('White')
    end
    text.stroke_width(6)
    text.line(framewidth + klapan + otstavheight - 3, 0,
              framewidth + klapan + otstavheight - 3, 75)
    text.line(framewidth + klapan + otstavheight - 40, 75,
              framewidth + klapan + otstavheight + 34, 75)
    text.line(framewidth + klapan + otstavheight - 3, coverypx - 75,
              framewidth + klapan + otstavheight - 3, coverypx)
    text.draw(cover)
    cover.units = PixelsPerInchResolution
    cover.density = '300x300'
    write_to_dir(page.book.order.name, cover, 0)
    clear_mem([frontcover, otstav, backsidecover, cover],
              [page, coverxpx, coverypx, klapan, otstavheight, framewidth, frameheight])
  end

  # add background
  def add_background(bookpage, page, align)
    frame_width    = @xpx / 2
    frame_height   = @ypx
    background_photo = Image.read(URI.decode('public' + page.background))[0].blur_image(0, 2)
    background_photo = resize_to_fill(background_photo, frame_width, frame_height)
    clear_mem([], [page, frame_width, frame_height])
    bookpage.composite!(background_photo, NorthWestGravity, 0, 0, OverCompositeOp) if align == 'left'
    bookpage.composite!(background_photo, NorthEastGravity, 0, 0, OverCompositeOp) if align == 'right'
  end

  # Template 1
  def merge_page_template_1(page)
    frame_width    = @xpx / 2
    frame_height   = @ypx
    photodone = []
    resize_and_move(page, 0, frame_width, frame_height, photodone)
    clear_mem([], [page, frame_width, frame_height])
    photodone[0]
  end

  # Template 2
  def merge_page_template_2(page)
    bookpage = Image.new(@xpx / 2, @ypx) { self.background_color = page.bgcolor }
    add_background(bookpage, page, 'left') if page.background
    obrez = 5 * 11.811
    frame_width    = 4 * @xpx / 10 - 2 * obrez
    frame_height   = 4 * @ypx / 5 - 2 * obrez
    photodone = []
    resize_and_move(page, 0, frame_width, frame_height, photodone)
    clear_mem([], [page, frame_width, frame_height])
    bookpage.composite!(photodone[0], NorthWestGravity, @ypx / 10 + obrez, @ypx / 10 + obrez, OverCompositeOp)
  end

  # Template 3
  def merge_page_template_3(page)
    bookpage = Image.new(@xpx / 2, @ypx) { self.background_color = page.bgcolor }
    add_background(bookpage, page, 'left') if page.background
    obrez = 5 * 11.811
    frame_width    = 3 * @xpx / 10 - 2 * obrez
    frame_height   = 3 * @ypx / 5 - 2 * obrez
    photodone = []
    resize_and_move(page, 0, frame_width, frame_height, photodone)
    clear_mem([], [page, frame_width, frame_height])
    bookpage.composite!(photodone[0], NorthWestGravity, @ypx / 5 + obrez, @ypx / 5 + obrez, OverCompositeOp)
  end

  # Template 4
  def merge_page_template_4(page)
    bookpage = Image.new(@xpx / 2, @ypx) { self.background_color = page.bgcolor }
    add_background(bookpage, page, 'left') if page.background
    obrez = 5 * 11.811
    width = 4 * @xpx / 10 - 2 * obrez
    height = 4 * @ypx / 5 - 2 * obrez
    frame_width    = 0.33 * width
    frame_height   = 0.33 * height
    photodone = []
    (0..8).each do |i|
      resize_and_move(page, i, frame_width, frame_height, photodone)
    end
    clear_mem([], [page, frame_width, frame_height])
    bookpage.composite!(photodone[0],
                        NorthWestGravity,
                        @ypx / 10 + obrez,
                        @ypx / 10 + obrez,
                        OverCompositeOp)
    bookpage.composite!(photodone[1],
                        NorthWestGravity,
                        0.335 * width + @ypx / 10 + obrez,
                        @ypx / 10 + obrez,
                        OverCompositeOp)
    bookpage.composite!(photodone[2],
                        NorthWestGravity,
                        0.67 * width + @ypx / 10 + obrez,
                        @ypx / 10 + obrez,
                        OverCompositeOp)
    bookpage.composite!(photodone[3],
                        NorthWestGravity,
                        @ypx / 10 + obrez,
                        0.335 * width + @ypx / 10 + obrez,
                        OverCompositeOp)
    bookpage.composite!(photodone[4],
                        NorthWestGravity,
                        0.335 * width + @ypx / 10 + obrez,
                        0.335 * width + @ypx / 10 + obrez,
                        OverCompositeOp)
    bookpage.composite!(photodone[5],
                        NorthWestGravity,
                        0.67 * width + @ypx / 10 + obrez,
                        0.335 * width + @ypx / 10 + obrez,
                        OverCompositeOp)
    bookpage.composite!(photodone[6],
                        NorthWestGravity,
                        @ypx / 10 + obrez,
                        0.67 * width + @ypx / 10 + obrez,
                        OverCompositeOp)
    bookpage.composite!(photodone[7],
                        NorthWestGravity,
                        0.335 * width + @ypx / 10 + obrez,
                        0.67 * width + @ypx / 10 + obrez,
                        OverCompositeOp)
    bookpage.composite!(photodone[8],
                        NorthWestGravity,
                        0.67 * width + @ypx / 10 + obrez,
                        0.67 * width + @ypx / 10 + obrez,
                        OverCompositeOp)
  end

  # Template 5
  def merge_page_template_5(page)
    bookpage = Image.new(@xpx / 2, @ypx) { self.background_color = page.bgcolor }
    add_background(bookpage, page, 'left') if page.background
    frame_width    = 3 * @xpx / 10
    frame_height   = @ypx
    photodone = []
    resize_and_move(page, 0, frame_width, frame_height, photodone)
    clear_mem([], [page, frame_width, frame_height])
    bookpage.composite!(photodone[0], NorthWestGravity, @ypx / 5, 0, OverCompositeOp)
  end

  # Template 6
  def merge_page_template_6(page)
    bookpage = Image.new(@xpx / 2, @ypx) { self.background_color = page.bgcolor }
    add_background(bookpage, page, 'left') if page.background
    frame_width    = @xpx / 2
    frame_height   = 3 * @ypx / 5
    photodone = []
    resize_and_move(page, 0, frame_width, frame_height, photodone)
    clear_mem([], [page, frame_width, frame_height])
    bookpage.composite!(photodone[0], NorthWestGravity, 0, @ypx / 5, OverCompositeOp)
  end

  # Template 7
  def merge_page_template_7(page)
    bookpage = Image.new(@xpx / 2, @ypx) { self.background_color = page.bgcolor }
    add_background(bookpage, page, 'left') if page.background
    frame_width    = 0.495 * @xpx / 2
    frame_height   = 0.495 * (3 * @ypx / 5)
    photodone = []
    (0..3).each do |i|
      resize_and_move(page, i, frame_width, frame_height, photodone)
    end
    clear_mem([], [page, frame_width, frame_height])
    if page.pagenum.odd?
      bookpage.composite!(photodone[0],
                          NorthWestGravity, 0, @ypx / 5, OverCompositeOp)
      bookpage.composite!(photodone[1],
                          NorthWestGravity, 0.5 * @ypx, @ypx / 5, OverCompositeOp)
      bookpage.composite!(photodone[2],
                          NorthWestGravity, 0, 0.505 * (3 * @ypx / 5) + @ypx / 5, OverCompositeOp)
      bookpage.composite!(photodone[3],
                          NorthWestGravity, 0.5 * @ypx, 0.505 * (3 * @ypx / 5) + @ypx / 5, OverCompositeOp)
    else
      bookpage.composite!(photodone[0],
                          NorthEastGravity, 0, @ypx / 5, OverCompositeOp)
      bookpage.composite!(photodone[1],
                          NorthEastGravity, 0.5 * @ypx, @ypx / 5, OverCompositeOp)
      bookpage.composite!(photodone[2],
                          NorthEastGravity, 0, 0.505 * (3 * @ypx / 5) + @ypx / 5, OverCompositeOp)
      bookpage.composite!(photodone[3],
                          NorthEastGravity, 0.5 * @ypx, 0.505 * (3 * @ypx / 5) + @ypx / 5, OverCompositeOp)
    end
  end

  # Template 8
  def merge_page_template_8(page)
    bookpage = Image.new(@xpx / 2, @ypx) { self.background_color = page.bgcolor }
    add_background(bookpage, page, 'left') if page.background
    obrez = 5 * 11.811
    width = 9 * @xpx / 20 - 2 * obrez
    height = 9 * @ypx / 10 - 2 * obrez
    frame_width    = 0.495 * width
    frame_height   = 0.33 * height
    photodone      = []
    (0..3).each do |i|
      if i > 2
        frame_width    = 0.495 * width
        frame_height   = height
      end
      resize_and_move(page, i, frame_width, frame_height, photodone)
    end
    clear_mem([], [page, frame_width, frame_height])
    bookpage.composite!(photodone[0],
                        NorthWestGravity, @ypx / 20 + obrez, @ypx / 20 + obrez, OverCompositeOp)
    bookpage.composite!(photodone[1],
                        NorthWestGravity, @ypx / 20 + obrez, 0.335 * height + @ypx / 20 + obrez, OverCompositeOp)
    bookpage.composite!(photodone[2],
                        NorthWestGravity, @ypx / 20 + obrez, 0.67 * height + @ypx / 20 + obrez, OverCompositeOp)
    bookpage.composite!(photodone[3],
                        NorthWestGravity, 0.5 * width + @ypx / 20 + obrez, @ypx / 20 + obrez, OverCompositeOp)
  end

  # Template 9
  def merge_page_template_9(page)
    bookpage = Image.new(@xpx / 2, @ypx) { self.background_color = page.bgcolor }
    add_background(bookpage, page, 'left') if page.background
    frame_width    = 0.495 * 0.8 * @xpx / 2
    frame_height   = 0.3675 * 0.8 * @xpx / 2
    photodone = []
    (0..5).each do |i|
      resize_and_move(page, i, frame_width, frame_height, photodone)
    end
    clear_mem([], [page, frame_width, frame_height])
    if page.pagenum.odd?
      bookpage.composite!(photodone[0],
                          NorthWestGravity, 0.06 * @xpx, @ypx / 20, OverCompositeOp)
      bookpage.composite!(photodone[1],
                          NorthWestGravity, 0.06 * @xpx + 0.505 * 0.8 * @xpx / 2, @ypx / 20, OverCompositeOp)
      bookpage.composite!(photodone[2],
                          NorthWestGravity, 0.06 * @xpx, @ypx / 20 + 0.3775 * 0.8 * @xpx / 2, OverCompositeOp)
      bookpage.composite!(photodone[3],
                          NorthWestGravity, 0.06 * @xpx + 0.505 * 0.8 * @xpx / 2, @ypx / 20 + 0.3775 * 0.8 * @xpx / 2, OverCompositeOp)
      bookpage.composite!(photodone[4],
                          NorthWestGravity, 0.06 * @xpx, @ypx / 20 + 0.3775 * 0.8 * @xpx, OverCompositeOp)
      bookpage.composite!(photodone[5],
                          NorthWestGravity, 0.06 * @xpx + 0.505 * 0.8 * @xpx / 2, @ypx / 20 + 0.3775 * 0.8 * @xpx, OverCompositeOp)
    else
      bookpage.composite!(photodone[0],
                          NorthEastGravity, 0.06 * @xpx, @ypx / 20, OverCompositeOp)
      bookpage.composite!(photodone[1],
                          NorthEastGravity, 0.06 * @xpx + 0.505 * 0.8 * @xpx / 2, @ypx / 20, OverCompositeOp)
      bookpage.composite!(photodone[2],
                          NorthEastGravity, 0.06 * @xpx, @ypx / 20 + 0.3775 * 0.8 * @xpx / 2, OverCompositeOp)
      bookpage.composite!(photodone[3],
                          NorthEastGravity, 0.06 * @xpx + 0.505 * 0.8 * @xpx / 2, @ypx / 20 + 0.3775 * 0.8 * @xpx / 2, OverCompositeOp)
      bookpage.composite!(photodone[4],
                          NorthEastGravity, 0.06 * @xpx, @ypx / 20 + 0.3775 * 0.8 * @xpx, OverCompositeOp)
      bookpage.composite!(photodone[5],
                          NorthEastGravity, 0.06 * @xpx + 0.505 * 0.8 * @xpx / 2, @ypx / 20 + 0.3775 * 0.8 * @xpx, OverCompositeOp)
    end
  end

  # Template 10
  def merge_page_template_10(page)
    bookpage = Image.new(@xpx / 2, @ypx) { self.background_color = page.bgcolor }
    add_background(bookpage, page, 'left') if page.background
    frame_width    = 0.495 * 0.8 * @xpx / 2
    frame_height   = 0.75 * 0.8 * @xpx / 2
    photodone = []
    (0..1).each do |i|
      resize_and_move(page, i, frame_width, frame_height, photodone)
    end
    clear_mem([], [page, frame_width, frame_height])
    if page.pagenum.odd?
      bookpage.composite!(photodone[0],
                          NorthWestGravity, 0.06 * @xpx, @ypx / 5, OverCompositeOp)
      bookpage.composite!(photodone[1],
                          NorthWestGravity, 0.06 * @xpx + 0.505 * 0.8 * @xpx / 2, @ypx / 5, OverCompositeOp)
    else
      bookpage.composite!(photodone[0],
                          NorthEastGravity, 0.06 * @xpx, @ypx / 5, OverCompositeOp)
      bookpage.composite!(photodone[1],
                          NorthEastGravity, 0.06 * @xpx + 0.505 * 0.8 * @xpx / 2, @ypx / 5, OverCompositeOp)
    end
  end

  # Template 11
  def merge_page_template_11(page)
    bookpage = Image.new(@xpx / 2, @ypx) { self.background_color = page.bgcolor }
    add_background(bookpage, page, 'left') if page.background
    frame_width    = 0.495 * 0.6 * @xpx / 2
    frame_height   = 0.7425 * 0.6 * @xpx / 2
    photodone = []
    (0..3).each do |i|
      resize_and_move(page, i, frame_width, frame_height, photodone)
    end
    clear_mem([], [page, frame_width, frame_height])
    if page.pagenum.odd?
      bookpage.composite!(photodone[0],
                          NorthWestGravity, 0.108 * @xpx, @ypx / 20, OverCompositeOp)
      bookpage.composite!(photodone[1],
                          NorthWestGravity, 0.108 * @xpx + 0.505 * 0.6 * @xpx / 2, @ypx / 20, OverCompositeOp)
      bookpage.composite!(photodone[2],
                          NorthWestGravity, 0.108 * @xpx, @ypx / 20 + 0.7525 * 0.6 * @xpx / 2, OverCompositeOp)
      bookpage.composite!(photodone[3],
                          NorthWestGravity, 0.108 * @xpx + 0.505 * 0.6 * @xpx / 2, @ypx / 20 + 0.7525 * 0.6 * @xpx / 2, OverCompositeOp)
    else
      bookpage.composite!(photodone[0],
                          NorthEastGravity, 0.108 * @xpx, @ypx / 20, OverCompositeOp)
      bookpage.composite!(photodone[1],
                          NorthEastGravity, 0.108 * @xpx + 0.505 * 0.6 * @xpx / 2, @ypx / 20, OverCompositeOp)
      bookpage.composite!(photodone[2],
                          NorthEastGravity, 0.108 * @xpx, @ypx / 20 + 0.7525 * 0.6 * @xpx / 2, OverCompositeOp)
      bookpage.composite!(photodone[3],
                          NorthEastGravity, 0.108 * @xpx + 0.505 * 0.6 * @xpx / 2, @ypx / 20 + 0.7525 * 0.6 * @xpx / 2, OverCompositeOp)
    end
  end

  # Template 11
  def merge_page_template_101(page)
    bookpage = Image.new(@xpx, @ypx) { self.background_color = page.bgcolor }
    frame_width    = @xpx
    frame_height   = @ypx
    photodone      = []
    resize_and_move(page, 0, frame_width, frame_height, photodone)
    clear_mem([], [page, frame_width, frame_height])
    bookpage.composite!(photodone[0], NorthWestGravity, 0, 0, OverCompositeOp)
  end

  # Template 12
  def merge_page_template_102(page)
    bookpage = Image.new(@xpx, @ypx) { self.background_color = page.bgcolor }
    background_page = page.book.bookpages[page.pagenum + 1]
    add_background(bookpage, background_page, 'right') if background_page.background
    obrez = 5 * 11.811
    width = 9 * @xpx / 10 - 2 * obrez
    height = 9 * @ypx / 10 - 2 * obrez
    frame_width    = 0.75 * @xpx
    frame_height   = @ypx
    photodone      = []
    (0..3).each do |i|
      if i.positive?
        frame_width    = 0.25 * width
        frame_height   = 0.33 * height
      end
      resize_and_move(page, i, frame_width, frame_height, photodone)
    end
    clear_mem([], [page, frame_width, frame_height])
    bookpage.composite!(photodone[0],
                        NorthWestGravity,
                        0, 0,
                        OverCompositeOp)
    bookpage.composite!(photodone[1],
                        NorthEastGravity,
                        @ypx / 60 + obrez,
                        @ypx / 30 + obrez,
                        OverCompositeOp)
    bookpage.composite!(photodone[2],
                        NorthEastGravity,
                        @ypx / 60 + obrez,
                        0.335 * height + @ypx / 30 + @ypx / 60 + obrez,
                        OverCompositeOp)
    bookpage.composite!(photodone[3],
                        NorthEastGravity,
                        @ypx / 60 + obrez,
                        0.67 * height + @ypx / 30 + 2 * @ypx / 60 + obrez,
                        OverCompositeOp)
  end

  # Template 13
  def merge_page_template_103(page)
    bookpage = Image.new(@xpx, @ypx) { self.background_color = page.bgcolor }
    add_background(bookpage, page, 'left') if page.background
    obrez = 5 * 11.811
    width = 9 * @xpx / 10 - 2 * obrez
    height = 9 * @ypx / 10 - 2 * obrez
    frame_width    = 0.25 * width
    frame_height   = 0.33 * height
    photodone      = []
    (0..3).each do |i|
      if i > 2
        frame_width    = 0.75 * @xpx
        frame_height   = @ypx
      end
      resize_and_move(page, i, frame_width, frame_height, photodone)
    end
    clear_mem([], [page, frame_width, frame_height])
    bookpage.composite!(photodone[0],
                        NorthWestGravity,
                        @ypx / 60 + obrez,
                        @ypx / 30 + obrez,
                        OverCompositeOp)
    bookpage.composite!(photodone[1],
                        NorthWestGravity,
                        @ypx / 60 + obrez,
                        0.335 * height + @ypx / 30 + @ypx / 60 + obrez,
                        OverCompositeOp)
    bookpage.composite!(photodone[2],
                        NorthWestGravity,
                        @ypx / 60 + obrez,
                        0.67 * height + @ypx / 30 + 2 * @ypx / 60 + obrez,
                        OverCompositeOp)
    bookpage.composite!(photodone[3],
                        NorthEastGravity,
                        0, 0,
                        OverCompositeOp)
  end

  # Template 14
  def merge_page_template_104(page)
    bookpage = Image.new(@xpx, @ypx) { self.background_color = page.bgcolor }
    background_page = page.book.bookpages[page.pagenum + 1]
    add_background(bookpage, background_page, 'right') if background_page.background
    frame_width    = 0.75 * @xpx
    frame_height   = @ypx
    photodone      = []
    (0..1).each do |i|
      if i.positive?
        frame_width    = 0.248 * @xpx
        frame_height   = @ypx
      end
      resize_and_move(page, i, frame_width, frame_height, photodone)
    end
    clear_mem([], [page, frame_width, frame_height])
    bookpage.composite!(photodone[0], NorthWestGravity, 0, 0, OverCompositeOp)
    bookpage.composite!(photodone[1], NorthEastGravity, 0, 0, OverCompositeOp)
  end

  # Template 15
  def merge_page_template_105(page)
    bookpage = Image.new(@xpx, @ypx) { self.background_color = page.bgcolor }
    add_background(bookpage, page, 'left') if page.background
    frame_width    = 0.248 * @xpx
    frame_height   = @ypx
    photodone      = []
    (0..1).each do |i|
      if i.positive?
        frame_width    = 0.75 * @xpx
        frame_height   = @ypx
      end
      resize_and_move(page, i, frame_width, frame_height, photodone)
    end
    clear_mem([], [page, frame_width, frame_height])
    bookpage.composite!(photodone[0], NorthWestGravity, 0, 0, OverCompositeOp)
    bookpage.composite!(photodone[1], NorthEastGravity, 0, 0, OverCompositeOp)
  end

  # Merging pages into two-page opening
  def merge_2_page(order_name, razvorot_pages)
    pages = []
    razvorot_pages.each_with_index do |bpage, i|
      pages[i] = template_choose(bpage) if bpage.images.present?
    end
    if pages.any?
      razvorot = Image.new(@xpx, @ypx)
      razvorot.composite!(pages[0], NorthWestGravity, 0, 0, OverCompositeOp) if pages[0]
      razvorot.composite!(pages[1], NorthEastGravity, 0, 0, OverCompositeOp) if pages[1]
      razvorot.units = PixelsPerInchResolution
      razvorot.density = '300x300'
      razvorot_num = razvorot_pages.last.pagenum / 2
      write_to_dir(order_name, razvorot, razvorot_num)
      pages.clear
      clear_mem([razvorot], [order_name, razvorot_pages, razvorot_num])
    end
  end

  # Saving two-page opening
  def write_to_dir(order_name, file, razvorot_num)
    path = 'public/orders/' + order_name
    Dir.mkdir('public/orders') unless File.exist?('public/orders')
    Dir.mkdir(path) unless File.exist?(path)
    file_name = razvorot_num < 10 ? '0' + razvorot_num.to_s + '.jpg' : razvorot_num.to_s + '.jpg'
    file.write(path + '/' + file_name)
  end

  # Archivating book
  def ziporder(path)
    require 'zip'
    path.sub!(%r{/$}, '')
    archive = File.join('public/orders/', File.basename(path)) + '.zip'
    FileUtils.rm archive, force: true
    Zip::File.open(archive, 'w') do |zip_file|
      Dir["#{path}/**/**"].reject { |f| f == archive }.each do |file|
        zip_file.add(file.sub(path + '/', ''), file)
      end
    end
    FileUtils.rm_rf(path)
  end

  # Test line
  def text_fit?(page, text, width, frameheight)
    tmp_image = Image.new(width, 500)
    drawing = Draw.new
    drawing.annotate(tmp_image, 0, 0, 0, 0, text) do |txt|
      txt.gravity = CenterGravity
      txt.pointsize = page.book.fontsize.to_i * 0.01 * frameheight * 2
      txt.fill = page.book.fontcolor
      txt.font = 'public/assets/fonts/' + page.book.fontfamily + '.ttf'
    end
    metrics = drawing.get_multiline_type_metrics(tmp_image, text)
    (metrics.width < width)
  end

  # Add newline
  def fit_text(page, text, width, frameheight)
    separator = ' '
    line = ''
    if !text_fit?(page, text, width, frameheight) && text.include?(separator)
      i = 0
      text.split(separator).each do |word|
        tmp_line = i.zero? ? (line + word) : (line + separator + word)

        if text_fit?(page, tmp_line, width, frameheight)
          line += separator unless i.zero?
          line += word
        else
          line += '\n' unless i.zero?
          line += word
        end
        i += 1
      end
      text = line
    end
    text
  end
end
