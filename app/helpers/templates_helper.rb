module TemplatesHelper
  include Magick
  # Cover template 1
  def front_cover_1(page, frame_width, frame_height)
    image_frame_width = frame_width
    image_frame_height = frame_height
    photo_done = []
    image_frame = resize_and_move(page, 0, image_frame_width, image_frame_height, photo_done)
    front_cover = Image.new(frame_width, frame_height) { self.background_color = page.bgcolor }
    front_cover.composite!(image_frame, NorthWestGravity, 0, 0, OverCompositeOp)
    clear_mem([image_frame],
              [image_frame_width, image_frame_height])
    front_cover
  end

  # Cover template 2
  def front_cover_2(page, frame_width, frame_height)
    image_frame_width = 0.6 * frame_width
    image_frame_height = 0.6 * frame_height
    text_frame_width = frame_width
    text_frame_height = 0.3 * frame_height
    photo_done = []
    image_frame = resize_and_move(page, 0, image_frame_width, image_frame_height, photo_done)
    text_frame = text_frame_create(page, text_frame_width, text_frame_height, frame_height)
    front_cover = Magick::Image.new(frame_width, frame_height) { self.background_color = page.bgcolor }
    front_cover.composite!(image_frame, NorthWestGravity, 0.2 * frame_width, 0.1 * frame_height, OverCompositeOp)
    front_cover.composite!(text_frame, NorthWestGravity, 0, image_frame_height + 0.1 * frame_height, OverCompositeOp)
    clear_mem([image_frame, text_frame],
              [image_frame_width, image_frame_height, text_frame_width, text_frame_height])
    front_cover
  end

  # Cover template 3
  def front_cover_3(page, frame_width, frame_height)
    text_frame_width = 0.5 * frame_width
    text_frame_height = 0.5 * frame_height
    photo_done = []
    text_frame = text_frame_create(page, text_frame_width, text_frame_height, frame_height)
    front_cover = Image.new(frame_width, frame_height) { self.background_color = page.bgcolor }
    if page.images.present?
      image_frame_width = 0.45 * frame_width
      image_frame_height = 0.45 * frame_height
      image_frame = resize_and_move(page, 0, image_frame_width, image_frame_height, photo_done)
      front_cover.composite!(image_frame, NorthWestGravity, 0.05 * frame_width, 0.275 * frame_height, OverCompositeOp)
    end
    front_cover.composite!(text_frame, NorthWestGravity, 0.5 * frame_width, 0.25 * frame_height, OverCompositeOp)
    clear_mem([image_frame, text_frame],
              [image_frame_width, image_frame_height, text_frame_width, text_frame_height])
    front_cover
  end

  # Cover template 4
  def front_cover_4(page, frame_width, frame_height)
    image_frame_width = frame_width
    image_frame_height = 0.7 * frame_height
    text_frame_width = frame_width
    text_frame_height = 0.3 * frame_height
    photo_done = []
    image_frame = resize_and_move(page, 0, image_frame_width, image_frame_height, photo_done)
    text_frame = text_frame_create(page, text_frame_width, text_frame_height, frame_height)
    front_cover = Image.new(frame_width, frame_height) { self.background_color = page.bgcolor }
    front_cover.composite!(image_frame, NorthWestGravity, 0, 0, OverCompositeOp)
    front_cover.composite!(text_frame, NorthWestGravity, 0, image_frame_height, OverCompositeOp)
    clear_mem([image_frame, text_frame],
              [image_frame_width, image_frame_height, text_frame_width, text_frame_height])
    front_cover
  end

  # Cover template 5
  def front_cover_5(page, frame_width, frame_height)
    image_frame_width = 0.45 * frame_width
    image_frame_height = 0.95 * frame_height
    text_frame_width = 0.5 * frame_width
    text_frame_height = 0.5 * frame_height
    photo_done = []
    image_frame = resize_and_move(page, 0, image_frame_width, image_frame_height, photo_done)
    text_frame = text_frame_create(page, text_frame_width, text_frame_height, frame_height)
    front_cover = Image.new(frame_width, frame_height) { self.background_color = page.bgcolor }
    front_cover.composite!(image_frame, NorthWestGravity, 0.025 * frame_width, 0.025 * frame_height, OverCompositeOp)
    front_cover.composite!(text_frame, NorthWestGravity, 0.5 * frame_width, 0.25 * frame_height, OverCompositeOp)
    clear_mem([image_frame, text_frame],
              [image_frame_width, image_frame_height, text_frame_width, text_frame_height])
    front_cover
  end

  # Cover template 6
  def front_cover_6(page, frame_width, frame_height)
    text_frame_create(page, frame_width, frame_height, frame_height)
  end

  # Cover template 7
  def front_cover_7(page, frame_width, frame_height)
    image_frame_width = 0.2235 * frame_width
    image_frame_height = 0.2235 * frame_height
    text_frame_width = 0.447 * frame_width + frame_width / 500
    text_frame_height = 0.2235 * frame_height
    text_frame = text_frame_create(page, text_frame_width, text_frame_height, frame_height)
    front_cover = Image.new(frame_width, frame_height) { self.background_color = page.bgcolor }
    photo_done = []
    (0..13).each { |i| resize_and_move(page, i, image_frame_width, image_frame_height, photo_done) }
    front_cover.composite!(photo_done[0],
                           NorthWestGravity,
                           frame_width / 20, frame_height / 20,
                           OverCompositeOp)
    front_cover.composite!(photo_done[1],
                           NorthWestGravity,
                           frame_width / 20 + image_frame_width + frame_width / 500, frame_height / 20,
                           OverCompositeOp)
    front_cover.composite!(photo_done[2],
                           NorthWestGravity,
                           frame_width / 20 + 2 * image_frame_width + 2 * frame_width / 500, frame_height / 20,
                           OverCompositeOp)
    front_cover.composite!(photo_done[3],
                           NorthWestGravity,
                           frame_width / 20 + 3 * image_frame_width + 3 * frame_width / 500, frame_height / 20,
                           OverCompositeOp)
    front_cover.composite!(photo_done[4],
                           NorthWestGravity,
                           frame_width / 20, frame_height / 20 + image_frame_height + frame_height / 500,
                           OverCompositeOp)
    front_cover.composite!(photo_done[5],
                           NorthWestGravity,
                           frame_width / 20 + image_frame_width + frame_width / 500,
                           frame_height / 20 + image_frame_height + frame_height / 500,
                           OverCompositeOp)
    front_cover.composite!(photo_done[6],
                           NorthWestGravity,
                           frame_width / 20 + 2 * image_frame_width + 2 * frame_width / 500,
                           frame_height / 20 + image_frame_height + frame_height / 500,
                           OverCompositeOp)
    front_cover.composite!(photo_done[7],
                           NorthWestGravity,
                           frame_width / 20 + 3 * image_frame_width + 3 * frame_width / 500,
                           frame_height / 20 + image_frame_height + frame_height / 500,
                           OverCompositeOp)
    front_cover.composite!(photo_done[8],
                           NorthWestGravity,
                           frame_width / 20,
                           frame_height / 20 + 2 * image_frame_height + 2 * frame_height / 500,
                           OverCompositeOp)
    front_cover.composite!(photo_done[9],
                           NorthWestGravity,
                           frame_width / 20 + image_frame_width + frame_width / 500,
                           frame_height / 20 + 2 * image_frame_height + 2 * frame_height / 500,
                           OverCompositeOp)
    front_cover.composite!(text_frame,
                           NorthWestGravity,
                           frame_width / 20 + 2 * image_frame_width + 2 * frame_width / 500,
                           frame_height / 20 + 2 * image_frame_height + 2 * frame_height / 500,
                           OverCompositeOp)
    front_cover.composite!(photo_done[10],
                           NorthWestGravity,
                           frame_width / 20, frame_height / 20 + 3 * image_frame_height + 3 * frame_width / 500,
                           OverCompositeOp)
    front_cover.composite!(photo_done[11],
                           NorthWestGravity,
                           ramewidth / 20 + image_frame_width + frame_width / 500,
                           frame_height / 20 + 3 * image_frame_height + 3 * frame_height / 500,
                           OverCompositeOp)
    front_cover.composite!(photo_done[12],
                           NorthWestGravity,
                           frame_width / 20 + 2 * image_frame_width + 2 * frame_width / 500,
                           frame_height / 20 + 3 * image_frame_height + 3 * frame_height / 500,
                           OverCompositeOp)
    front_cover.composite!(photo_done[13],
                           NorthWestGravity,
                           frame_width / 20 + 3 * image_frame_width + 3 * frame_width / 500,
                           frame_height / 20 + 3 * image_frame_height + 3 * frame_height / 500,
                           OverCompositeOp)
    clear_mem([text_frame], [image_frame_width, image_frame_height, text_frame_width, text_frame_height])
    front_cover
  end

  # Bookpage_width
  def bookpage_width(xpx)
    xpx.odd? && page.pagenum.odd? ? ((xpx + 1) / 2) : (xpx / 2)
  end

  # Template 1
  def merge_page_template_1(page)
    width = bookpage_width(@xpx)
    frame_width    = width
    frame_height   = @ypx
    photo_done = []
    resize_and_move(page, 0, frame_width, frame_height, photo_done)
    clear_mem([], [page, frame_width, frame_height])
    photo_done[0]
  end

  # Template 2
  def merge_page_template_2(page)
    width = bookpage_width(@xpx)
    bookpage = Image.new(width, @ypx) { self.background_color = page.bgcolor }
    add_background(bookpage, page, 'left') if page.background
    edge = 5 * 11.811
    frame_width    = 0.4 * @xpx - 2 * edge
    frame_height   = 0.8 * @ypx - 2 * edge
    photo_done = []
    resize_and_move(page, 0, frame_width, frame_height, photo_done)
    clear_mem([], [page, frame_width, frame_height])
    bookpage.composite!(photo_done[0], NorthWestGravity, @ypx / 10 + edge, @ypx / 10 + edge, OverCompositeOp)
  end

  # Template 3
  def merge_page_template_3(page)
    width = bookpage_width(@xpx)
    bookpage = Image.new(width, @ypx) { self.background_color = page.bgcolor }
    add_background(bookpage, page, 'left') if page.background
    edge = 5 * 11.811
    frame_width    = 0.3 * @xpx - 2 * edge
    frame_height   = 0.6 * @ypx - 2 * edge
    photo_done = []
    resize_and_move(page, 0, frame_width, frame_height, photo_done)
    clear_mem([], [page, frame_width, frame_height])
    bookpage.composite!(photo_done[0], NorthWestGravity, @ypx / 5 + edge, @ypx / 5 + edge, OverCompositeOp)
  end

  # Template 4
  def merge_page_template_4(page)
    width = bookpage_width(@xpx)
    bookpage = Image.new(width, @ypx) { self.background_color = page.bgcolor }
    add_background(bookpage, page, 'left') if page.background
    edge = 5 * 11.811
    width = 0.4 * @xpx - 2 * edge
    height = 0.8 * @ypx - 2 * edge
    frame_width    = 0.33 * width
    frame_height   = 0.33 * height
    photo_done = []
    (0..8).each do |i|
      resize_and_move(page, i, frame_width, frame_height, photo_done)
    end
    clear_mem([], [page, frame_width, frame_height])
    bookpage.composite!(photo_done[0],
                        NorthWestGravity,
                        @ypx / 10 + edge,
                        @ypx / 10 + edge,
                        OverCompositeOp)
    bookpage.composite!(photo_done[1],
                        NorthWestGravity,
                        0.335 * width + @ypx / 10 + edge,
                        @ypx / 10 + edge,
                        OverCompositeOp)
    bookpage.composite!(photo_done[2],
                        NorthWestGravity,
                        0.67 * width + @ypx / 10 + edge,
                        @ypx / 10 + edge,
                        OverCompositeOp)
    bookpage.composite!(photo_done[3],
                        NorthWestGravity,
                        @ypx / 10 + edge,
                        0.335 * width + @ypx / 10 + edge,
                        OverCompositeOp)
    bookpage.composite!(photo_done[4],
                        NorthWestGravity,
                        0.335 * width + @ypx / 10 + edge,
                        0.335 * width + @ypx / 10 + edge,
                        OverCompositeOp)
    bookpage.composite!(photo_done[5],
                        NorthWestGravity,
                        0.67 * width + @ypx / 10 + edge,
                        0.335 * width + @ypx / 10 + edge,
                        OverCompositeOp)
    bookpage.composite!(photo_done[6],
                        NorthWestGravity,
                        @ypx / 10 + edge,
                        0.67 * width + @ypx / 10 + edge,
                        OverCompositeOp)
    bookpage.composite!(photo_done[7],
                        NorthWestGravity,
                        0.335 * width + @ypx / 10 + edge,
                        0.67 * width + @ypx / 10 + edge,
                        OverCompositeOp)
    bookpage.composite!(photo_done[8],
                        NorthWestGravity,
                        0.67 * width + @ypx / 10 + edge,
                        0.67 * width + @ypx / 10 + edge,
                        OverCompositeOp)
  end

  # Template 5
  def merge_page_template_5(page)
    width = bookpage_width(@xpx)
    bookpage = Image.new(width, @ypx) { self.background_color = page.bgcolor }
    add_background(bookpage, page, 'left') if page.background
    frame_width    = 0.3 * @xpx
    frame_height   = @ypx
    photo_done = []
    resize_and_move(page, 0, frame_width, frame_height, photo_done)
    clear_mem([], [page, frame_width, frame_height])
    bookpage.composite!(photo_done[0], NorthWestGravity, 0.2 * @ypx, 0, OverCompositeOp)
  end

  # Template 6
  def merge_page_template_6(page)
    width = bookpage_width(@xpx)
    bookpage = Image.new(width, @ypx) { self.background_color = page.bgcolor }
    add_background(bookpage, page, 'left') if page.background
    frame_width    = 0.5 * @xpx
    frame_height   = 0.6 * @ypx
    photo_done = []
    resize_and_move(page, 0, frame_width, frame_height, photo_done)
    clear_mem([], [page, frame_width, frame_height])
    bookpage.composite!(photo_done[0], NorthWestGravity, 0, @ypx / 5, OverCompositeOp)
  end

  # Template 7
  def merge_page_template_7(page)
    width = bookpage_width(@xpx)
    bookpage = Image.new(width, @ypx) { self.background_color = page.bgcolor }
    add_background(bookpage, page, 'left') if page.background
    frame_width    = 0.495 * (0.5 * @xpx)
    frame_height   = 0.495 * (0.6 * @ypx)
    photo_done = []
    (0..3).each do |i|
      resize_and_move(page, i, frame_width, frame_height, photo_done)
    end
    clear_mem([], [page, frame_width, frame_height])
    if page.pagenum.odd?
      bookpage.composite!(photo_done[0],
                          NorthWestGravity, 0, @ypx / 5, OverCompositeOp)
      bookpage.composite!(photo_done[1],
                          NorthWestGravity, 0.5 * @ypx, @ypx / 5, OverCompositeOp)
      bookpage.composite!(photo_done[2],
                          NorthWestGravity, 0, 0.505 * (0.6 * @ypx) + @ypx / 5, OverCompositeOp)
      bookpage.composite!(photo_done[3],
                          NorthWestGravity, 0.5 * @ypx, 0.505 * (0.6 * @ypx) + @ypx / 5, OverCompositeOp)
    else
      bookpage.composite!(photo_done[0],
                          NorthEastGravity, 0, @ypx / 5, OverCompositeOp)
      bookpage.composite!(photo_done[1],
                          NorthEastGravity, 0.5 * @ypx, @ypx / 5, OverCompositeOp)
      bookpage.composite!(photo_done[2],
                          NorthEastGravity, 0, 0.505 * (0.6 * @ypx) + @ypx / 5, OverCompositeOp)
      bookpage.composite!(photo_done[3],
                          NorthEastGravity, 0.5 * @ypx, 0.505 * (0.6 * @ypx) + @ypx / 5, OverCompositeOp)
    end
  end

  # Template 8
  def merge_page_template_8(page)
    width = bookpage_width(@xpx)
    bookpage = Image.new(width, @ypx) { self.background_color = page.bgcolor }
    add_background(bookpage, page, 'left') if page.background
    edge = 5 * 11.811
    width = 0.45 * @xpx - 2 * edge
    height = 0.9 * @ypx - 2 * edge
    frame_width = 0.495 * width
    frame_height = 0.33 * height
    photo_done = []
    (0..3).each do |i|
      if i > 2
        frame_width    = 0.495 * width
        frame_height   = height
      end
      resize_and_move(page, i, frame_width, frame_height, photo_done)
    end
    clear_mem([], [page, frame_width, frame_height])
    bookpage.composite!(photo_done[0],
                        NorthWestGravity, @ypx / 20 + edge, @ypx / 20 + edge, OverCompositeOp)
    bookpage.composite!(photo_done[1],
                        NorthWestGravity, @ypx / 20 + edge, 0.335 * height + @ypx / 20 + edge, OverCompositeOp)
    bookpage.composite!(photo_done[2],
                        NorthWestGravity, @ypx / 20 + edge, 0.67 * height + @ypx / 20 + edge, OverCompositeOp)
    bookpage.composite!(photo_done[3],
                        NorthWestGravity, 0.5 * width + @ypx / 20 + edge, @ypx / 20 + edge, OverCompositeOp)
  end

  # Template 9
  def merge_page_template_9(page)
    width = bookpage_width(@xpx)
    bookpage = Image.new(width, @ypx) { self.background_color = page.bgcolor }
    add_background(bookpage, page, 'left') if page.background
    frame_width = 0.495 * 0.4 * @xpx
    frame_height = 0.3675 * 0.4 * @xpx
    photo_done = []
    (0..5).each do |i|
      resize_and_move(page, i, frame_width, frame_height, photo_done)
    end
    clear_mem([], [page, frame_width, frame_height])
    if page.pagenum.odd?
      bookpage.composite!(photo_done[0],
                          NorthWestGravity, 0.06 * @xpx, @ypx / 20, OverCompositeOp)
      bookpage.composite!(photo_done[1],
                          NorthWestGravity, 0.06 * @xpx + 0.505 * 0.4 * @xpx, @ypx / 20, OverCompositeOp)
      bookpage.composite!(photo_done[2],
                          NorthWestGravity, 0.06 * @xpx, @ypx / 20 + 0.3775 * 0.4 * @xpx, OverCompositeOp)
      bookpage.composite!(photo_done[3],
                          NorthWestGravity, 0.06 * @xpx + 0.505 * 0.4 * @xpx, @ypx / 20 + 0.3775 * 0.4 * @xpx, OverCompositeOp)
      bookpage.composite!(photo_done[4],
                          NorthWestGravity, 0.06 * @xpx, @ypx / 20 + 0.3775 * 0.8 * @xpx, OverCompositeOp)
      bookpage.composite!(photo_done[5],
                          NorthWestGravity, 0.06 * @xpx + 0.505 * 0.4 * @xpx, @ypx / 20 + 0.3775 * 0.8 * @xpx, OverCompositeOp)
    else
      bookpage.composite!(photo_done[0],
                          NorthEastGravity, 0.06 * @xpx, @ypx / 20, OverCompositeOp)
      bookpage.composite!(photo_done[1],
                          NorthEastGravity, 0.06 * @xpx + 0.505 * 0.4 * @xpx, @ypx / 20, OverCompositeOp)
      bookpage.composite!(photo_done[2],
                          NorthEastGravity, 0.06 * @xpx, @ypx / 20 + 0.3775 * 0.4 * @xpx, OverCompositeOp)
      bookpage.composite!(photo_done[3],
                          NorthEastGravity, 0.06 * @xpx + 0.505 * 0.4 * @xpx, @ypx / 20 + 0.3775 * 0.4 * @xpx, OverCompositeOp)
      bookpage.composite!(photo_done[4],
                          NorthEastGravity, 0.06 * @xpx, @ypx / 20 + 0.3775 * 0.8 * @xpx, OverCompositeOp)
      bookpage.composite!(photo_done[5],
                          NorthEastGravity, 0.06 * @xpx + 0.505 * 0.4 * @xpx, @ypx / 20 + 0.3775 * 0.8 * @xpx, OverCompositeOp)
    end
  end

  # Template 10
  def merge_page_template_10(page)
    width = bookpage_width(@xpx)
    bookpage = Image.new(width, @ypx) { self.background_color = page.bgcolor }
    add_background(bookpage, page, 'left') if page.background
    frame_width = 0.495 * 0.8 * @xpx / 2
    frame_height = 0.75 * 0.8 * @xpx / 2
    photo_done = []
    (0..1).each do |i|
      resize_and_move(page, i, frame_width, frame_height, photo_done)
    end
    clear_mem([], [page, frame_width, frame_height])
    if page.pagenum.odd?
      bookpage.composite!(photo_done[0],
                          NorthWestGravity, 0.06 * @xpx, @ypx / 5, OverCompositeOp)
      bookpage.composite!(photo_done[1],
                          NorthWestGravity, 0.06 * @xpx + 0.505 * 0.8 * @xpx / 2, @ypx / 5, OverCompositeOp)
    else
      bookpage.composite!(photo_done[0],
                          NorthEastGravity, 0.06 * @xpx, @ypx / 5, OverCompositeOp)
      bookpage.composite!(photo_done[1],
                          NorthEastGravity, 0.06 * @xpx + 0.505 * 0.8 * @xpx / 2, @ypx / 5, OverCompositeOp)
    end
  end

  # Template 11
  def merge_page_template_11(page)
    width = bookpage_width(@xpx)
    bookpage = Image.new(width, @ypx) { self.background_color = page.bgcolor }
    add_background(bookpage, page, 'left') if page.background
    frame_width    = 0.495 * 0.6 * @xpx / 2
    frame_height   = 0.7425 * 0.6 * @xpx / 2
    photo_done = []
    (0..3).each do |i|
      resize_and_move(page, i, frame_width, frame_height, photo_done)
    end
    clear_mem([], [page, frame_width, frame_height])
    if page.pagenum.odd?
      bookpage.composite!(photo_done[0],
                          NorthWestGravity, 0.108 * @xpx, @ypx / 20, OverCompositeOp)
      bookpage.composite!(photo_done[1],
                          NorthWestGravity, 0.108 * @xpx + 0.505 * 0.6 * @xpx / 2, @ypx / 20, OverCompositeOp)
      bookpage.composite!(photo_done[2],
                          NorthWestGravity, 0.108 * @xpx, @ypx / 20 + 0.7525 * 0.6 * @xpx / 2, OverCompositeOp)
      bookpage.composite!(photo_done[3],
                          NorthWestGravity, 0.108 * @xpx + 0.505 * 0.6 * @xpx / 2, @ypx / 20 + 0.7525 * 0.6 * @xpx / 2, OverCompositeOp)
    else
      bookpage.composite!(photo_done[0],
                          NorthEastGravity, 0.108 * @xpx, @ypx / 20, OverCompositeOp)
      bookpage.composite!(photo_done[1],
                          NorthEastGravity, 0.108 * @xpx + 0.505 * 0.6 * @xpx / 2, @ypx / 20, OverCompositeOp)
      bookpage.composite!(photo_done[2],
                          NorthEastGravity, 0.108 * @xpx, @ypx / 20 + 0.7525 * 0.6 * @xpx / 2, OverCompositeOp)
      bookpage.composite!(photo_done[3],
                          NorthEastGravity, 0.108 * @xpx + 0.505 * 0.6 * @xpx / 2, @ypx / 20 + 0.7525 * 0.6 * @xpx / 2, OverCompositeOp)
    end
  end

  # Template 11
  def merge_page_template_101(page)
    bookpage = Image.new(@xpx, @ypx) { self.background_color = page.bgcolor }
    frame_width    = @xpx
    frame_height   = @ypx
    photo_done = []
    resize_and_move(page, 0, frame_width, frame_height, photo_done)
    clear_mem([], [page, frame_width, frame_height])
    bookpage.composite!(photo_done[0], NorthWestGravity, 0, 0, OverCompositeOp)
  end

  # Template 12
  def merge_page_template_102(page)
    bookpage = Image.new(@xpx, @ypx) { self.background_color = page.bgcolor }
    background_page = page.book.bookpages[page.pagenum + 1]
    add_background(bookpage, background_page, 'right') if background_page.background
    edge = 5 * 11.811
    width = 9 * @xpx / 10 - 2 * edge
    height = 9 * @ypx / 10 - 2 * edge
    frame_width    = 0.75 * @xpx
    frame_height   = @ypx
    photo_done = []
    (0..3).each do |i|
      if i.positive?
        frame_width    = 0.25 * width
        frame_height   = 0.33 * height
      end
      resize_and_move(page, i, frame_width, frame_height, photo_done)
    end
    clear_mem([], [page, frame_width, frame_height])
    bookpage.composite!(photo_done[0],
                        NorthWestGravity,
                        0, 0,
                        OverCompositeOp)
    bookpage.composite!(photo_done[1],
                        NorthEastGravity,
                        @ypx / 60 + edge,
                        @ypx / 30 + edge,
                        OverCompositeOp)
    bookpage.composite!(photo_done[2],
                        NorthEastGravity,
                        @ypx / 60 + edge,
                        0.335 * height + @ypx / 30 + @ypx / 60 + edge,
                        OverCompositeOp)
    bookpage.composite!(photo_done[3],
                        NorthEastGravity,
                        @ypx / 60 + edge,
                        0.67 * height + @ypx / 30 + 2 * @ypx / 60 + edge,
                        OverCompositeOp)
  end

  # Template 13
  def merge_page_template_103(page)
    bookpage = Image.new(@xpx, @ypx) { self.background_color = page.bgcolor }
    add_background(bookpage, page, 'left') if page.background
    edge = 5 * 11.811
    width = 9 * @xpx / 10 - 2 * edge
    height = 9 * @ypx / 10 - 2 * edge
    frame_width    = 0.25 * width
    frame_height   = 0.33 * height
    photo_done = []
    (0..3).each do |i|
      if i > 2
        frame_width    = 0.75 * @xpx
        frame_height   = @ypx
      end
      resize_and_move(page, i, frame_width, frame_height, photo_done)
    end
    clear_mem([], [page, frame_width, frame_height])
    bookpage.composite!(photo_done[0],
                        NorthWestGravity,
                        @ypx / 60 + edge,
                        @ypx / 30 + edge,
                        OverCompositeOp)
    bookpage.composite!(photo_done[1],
                        NorthWestGravity,
                        @ypx / 60 + edge,
                        0.335 * height + @ypx / 30 + @ypx / 60 + edge,
                        OverCompositeOp)
    bookpage.composite!(photo_done[2],
                        NorthWestGravity,
                        @ypx / 60 + edge,
                        0.67 * height + @ypx / 30 + 2 * @ypx / 60 + edge,
                        OverCompositeOp)
    bookpage.composite!(photo_done[3],
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
    photo_done = []
    (0..1).each do |i|
      if i.positive?
        frame_width    = 0.248 * @xpx
        frame_height   = @ypx
      end
      resize_and_move(page, i, frame_width, frame_height, photo_done)
    end
    clear_mem([], [page, frame_width, frame_height])
    bookpage.composite!(photo_done[0], NorthWestGravity, 0, 0, OverCompositeOp)
    bookpage.composite!(photo_done[1], NorthEastGravity, 0, 0, OverCompositeOp)
  end

  # Template 15
  def merge_page_template_105(page)
    bookpage = Image.new(@xpx, @ypx) { self.background_color = page.bgcolor }
    add_background(bookpage, page, 'left') if page.background
    frame_width    = 0.248 * @xpx
    frame_height   = @ypx
    photo_done = []
    (0..1).each do |i|
      if i.positive?
        frame_width    = 0.75 * @xpx
        frame_height   = @ypx
      end
      resize_and_move(page, i, frame_width, frame_height, photo_done)
    end
    clear_mem([], [page, frame_width, frame_height])
    bookpage.composite!(photo_done[0], NorthWestGravity, 0, 0, OverCompositeOp)
    bookpage.composite!(photo_done[1], NorthEastGravity, 0, 0, OverCompositeOp)
  end
end