module HolstsHelper
  include Magick
  include TemplatesHelper
  def holst_1(holst, frame_width, frame_height)
    image_frame_width = frame_width
    image_frame_height = frame_height
    image_frame = resize_and_move(holst, image_frame_width, image_frame_height)
    front_cover = Image.new(frame_width, frame_height)
    front_cover.composite!(image_frame, NorthWestGravity, 0, 0, OverCompositeOp)
    front_cover
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
  def resize_and_move(holst, frame_width, frame_height)
    photo = Image.read(URI.decode('public' + holst.image.url))[0]
    move = translation(holst.positions, photo, frame_width, frame_height)
    photo = resize_to_fill(photo, frame_width, frame_height)
    photo_done = Image.new(frame_width, frame_height).composite!(photo, move[0], move[1], OverCompositeOp)
  end

  # Building holst
  def holst_create(holst)
    holst_width = holst.price_list.format.split('*')[0].to_i * 10 * 11.811
    holst_height = holst.price_list.format.split('*')[1].to_i * 10 * 11.811
    flap = 50 * 11.811

    front_cover = send(:"holst_#{1}", holst, holst_width, holst_height)

    print_holst = Image.new(holst_width, holst_height)
    print_holst.composite!(front_cover, CenterGravity, 0, 0, OverCompositeOp)
    print_holst.units = PixelsPerInchResolution
    print_holst.density = '300x300'

    flop_holst = print_holst.flop
    flopped_holst = Image.new(holst_width + 2 * flap, holst_height)
    flopped_holst.composite!(print_holst, CenterGravity, 0, 0, OverCompositeOp)
    flopped_holst.composite!(flop_holst, CenterGravity, -holst_width, 0, OverCompositeOp)
    flopped_holst.composite!(flop_holst, CenterGravity, holst_width, 0, OverCompositeOp)

    flip_holst = flopped_holst.flip
    flipped_holst = Image.new(holst_width + 2 * flap, holst_height + 2 * flap)
    flipped_holst.composite!(flopped_holst, CenterGravity, 0, 0, OverCompositeOp)
    flipped_holst.composite!(flip_holst, CenterGravity, 0, -holst_height, OverCompositeOp)
    flipped_holst.composite!(flip_holst, CenterGravity, 0, holst_height, OverCompositeOp)

    write_to_dir(Order.where(holst_id: holst.id).first.name, flipped_holst, 0)
  end

  # Saving
  def write_to_dir(order_name, file, razvorot_num)
    path = 'public/orders/' + order_name
    Dir.mkdir('public/orders') unless File.exist?('public/orders')
    Dir.mkdir(path) unless File.exist?(path)
    file_name = razvorot_num < 10 ? '0' + razvorot_num.to_s + '.jpg' : razvorot_num.to_s + '.jpg'
    file.write(path + '/' + file_name)
  end
end
