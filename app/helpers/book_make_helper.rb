module BookMakeHelper
  include Magick
  include TemplatesHelper
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
  def translation(position, photo, fw, fh)
    move_x = (- position.split('%')[0].to_f) * (fh * photo.columns - fw * photo.rows) / (100 * photo.rows)
    move_y = (- position.split('%')[1].to_f) * (fw * photo.rows - fh * photo.columns) / (100 * photo.columns)
    [move_x, move_y]
  end

  # Reading photo, insert it into frame and move it in
  def resize_and_move(page, i, frame_width, frame_height, photo_done = [])
    photo = Image.read(URI.decode('public' + page.images[i]))[0]
    move = translation(page.positions[i], photo, frame_width, frame_height)
    photo = resize_to_fill(photo, frame_width, frame_height)
    photo_done[i] = Image.new(frame_width, frame_height).composite!(photo, move[0], move[1], OverCompositeOp)
  end

  # Cover back_side
  def backside_cover(page, frame_width, frame_height)
    back_side_cover = Image.new(frame_width, frame_height) { self.background_color = page.background_color }
    logo = page.background_color == 'white' ? 'back_side_logo_black.png' : 'back_side_logo_white.png'
    logo = Image.read('app/assets/images/' + logo)[0]
    logo = logo.resize_to_fit!(11.811 * 50, 11.811 * 50)
    back_side_cover.composite!(logo, CenterGravity, 0, 0.25 * frame_height, OverCompositeOp)
  end

  # binding
  def binding(page, cover_height, binding_height)
    binding = Image.new(cover_height, binding_height) { self.background_color = page.background_color }
    text_to_paste = page.book.name.gsub(/(?:\n\r?|\r\n?)/, ' ')
    Draw.new.annotate(binding, 0, 0, 0, 0, text_to_paste) do
      self.font = 'app/assets/fonts/' + page.book.font_family + '.ttf'
      self.pointsize = 0.6 * binding.rows
      self.gravity = CenterGravity
      self.fill = page.book.font_color
    end
    binding
  end

  # Create text_frame
  def text_frame_create(page, text_frame_width, text_frame_height, frame_height)
    text = page.book.name
    text_lines = fit_text(page, text, text_frame_width, frame_height)
    text_frame = Image.new(text_frame_width, text_frame_height) { self.background_color = page.background_color }
    text_drawing(page, text_frame, text_lines, frame_height)
    text_frame
  end

  # Text drawing
  def text_drawing(page, text_frame, text, height)
    Draw.new.annotate(text_frame, 0, 0, 0, 0, text) do
      self.gravity = CenterGravity
      self.pointsize = page.book.font_size.to_i * 0.01 * height * 2
      self.fill = page.book.font_color
      self.font = 'app/assets/fonts/' + page.book.font_family + '.ttf'
    end
    text_frame
  end

  # Test line
  def text_fit?(page, text, width, frame_height)
    tmp_image = Image.new(width, frame_height)
    drawing = Draw.new
    drawing.annotate(tmp_image, 0, 0, 0, 0, text) do |txt|
      txt.gravity = CenterGravity
      txt.pointsize = page.book.font_size.to_i * 0.01 * frame_height * 2
      txt.fill = page.book.font_color
      txt.font = 'public/assets/fonts/' + page.book.font_family + '.ttf'
    end
    metrics = drawing.get_multiline_type_metrics(tmp_image, text)
    (metrics.width < width)
  end

  # Add newline
  def fit_text(page, text, width, frame_height)
    separator = ' '
    line = ''
    if !text_fit?(page, text, width, frame_height) && text.include?(separator)
      i = 0
      text.split(separator).each do |word|
        tmp_line = i.zero? ? (line + word) : (line + separator + word)

        line += text_fit?(page, tmp_line, width, frame_height) ? separator : '\n' unless i.zero?
        line += word
        i += 1
      end
      text = line
    end
    text
  end

  # Clear variables
  def clear_mem(images, variables)
    images.each(&:destroy!)
    variables.each do |_var|
      _var = nil
    end
  end

  # Building cover
  def cover_create(page)
    cover_height = page.book.price_list.cover_height
    cover_width = page.book.price_list.cover_width + ((page.book.book_pages.count - 1) / 2 - 10) * 11.811
    flap = page.book.price_list.format == '15см*15см' ? (11 * 11.811) : (15 * 11.811)
    binding_height = 11.811 * (page.book.book_pages.count - 1) / 2
    frame_width    = (cover_width - 2 * flap - binding_height) / 2
    frame_height   = cover_height - 2 * flap

    front_cover = send(:"front_cover_#{page.template}", page, frame_width, frame_height)
    binding = binding(page, cover_height, binding_height)
    backside_cover = backside_cover(page, frame_width, frame_height)

    cover = Image.new(cover_width, cover_height) { self.background_color = page.background_color }
    cover.composite!(backside_cover, NorthWestGravity, flap, flap, OverCompositeOp)
    cover.composite!(binding.rotate(-90), NorthWestGravity, frame_width + flap, 0, OverCompositeOp)
    cover.composite!(front_cover, NorthWestGravity, frame_width + flap + binding_height, flap, OverCompositeOp)
    text = Draw.new
    page.background_color == 'white' ? text.stroke('Black') : text.stroke('White')
    text.stroke_width(6)
    text.line(frame_width + flap + binding_height - 3, 0,
              frame_width + flap + binding_height - 3, 75)
    text.line(frame_width + flap + binding_height - 40, 75,
              frame_width + flap + binding_height + 34, 75)
    text.line(frame_width + flap + binding_height - 3, cover_height - 75,
              frame_width + flap + binding_height - 3, cover_height)
    text.draw(cover)
    cover.units = PixelsPerInchResolution
    cover.density = '300x300'
    write_to_dir(page.book.order.name, cover, 0)
    clear_mem([front_cover, binding, backside_cover, cover],
              [page, cover_width, cover_height, flap, binding_height, frame_width, frame_height])
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

  # Merging pages into two-page opening
  def merge_2_page(order_name, razvorot_pages)
    pages = []
    index = 0
    while index < razvorot_pages.size
      pages[index] = template_choose(razvorot_pages[index]) if razvorot_pages[index].images.present?
      index += 1
    end
    create_two_pages(razvorot_pages, pages, order_name) if pages.any?
    pages.clear
  end

  # Create two_pages
  def create_two_pages(razvorot_pages, pages, order_name)
    two_pages = Image.new(@xpx, @ypx)
    two_pages.composite!(pages[0], NorthWestGravity, 0, 0, OverCompositeOp) if pages[0]
    two_pages.composite!(pages[1], NorthEastGravity, 0, 0, OverCompositeOp) if pages[1]
    two_pages.units = PixelsPerInchResolution
    two_pages.density = '300x300'
    two_pages_num = razvorot_pages.last.page_num / 2
    write_to_dir(order_name, two_pages, two_pages_num)
    clear_mem([two_pages], [order_name, razvorot_pages, two_pages_num])
  end

  # Saving two-page opening
  def write_to_dir(order_name, file, razvorot_num)
    path = 'public/orders/' + order_name
    Dir.mkdir('public/orders') unless File.exist?('public/orders')
    Dir.mkdir(path) unless File.exist?(path)
    file_name = razvorot_num < 10 ? '0' + razvorot_num.to_s + '.jpg' : razvorot_num.to_s + '.jpg'
    file.write(path + '/' + file_name)
  end

  # Archiving book
  def zip_order(path)
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
end
