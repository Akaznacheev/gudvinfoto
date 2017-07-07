class BookpagesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_bookpage, only: %i(show edit update destroy)

  def index
    @bookpages = Bookpage.all
  end

  def show; end

  def new
    @bookpage = Bookpage.new
  end

  def edit; end

  def create
    @bookpage = Bookpage.new(bookpage_params)
    if @bookpage.save
      redirect_to @bookpage, notice: 'Bookpage was successfully created.'
    else
      render :new
    end
  end

  def imageupdate
    dragphoto = @bookpage.phgallery.images[photo[:photo_id].to_i]
    index = photo[:div_id].to_i
    imgchecks = @bookpage.phgallery.imgchecks
    imgchecks -= [@bookpage.images[index]] if @bookpage.images[index].present?
    imgchecks << dragphoto.url
    @bookpage.phgallery.update(imgchecks: imgchecks)
    images = @bookpage.images
    images[index] = dragphoto
    positions = @bookpage.positions
    positions[index] = '0px 0px'
    @bookpage.update(images:images, positions: positions)
  end

  def templateupdate
    template = params[:template].to_i

    if template.zero?
      @bookpage.update(images: [], positions: [], template: 0)
    elsif template == 10
      @bookpage.update(images: [], positions: [], template: 0)
      @bookpage2 = Bookpage.find(@bookpage.id + 1)
      @bookpage2.update(images: [], positions: [], template: 0)
    elsif template > 10
      @bookpage.update(template: template)
      @bookpage2 = Bookpage.find(@bookpage.id + 1)
      @bookpage2.update(images: [], positions: [], template: 0)
    else
      @bookpage.update(template: template)
      case @bookpage.pagenum.zero?
      when @bookpage.template == 1 || @bookpage.template == 3 || @bookpage.template == 5
        @bookpage.book.update(fontsize: 6)
      else
        @bookpage.book.update(fontsize: 3)
      end
    end
  end

  def bgcolorupdate
    @bookpage.update(bgcolor: params[:bgcolor])
    if @bookpage.pagenum.zero?
      book = @bookpage.book
      book.update(fontcolor: 'black') if params[:bgcolor] == 'white'
      book.update(fontcolor: 'white') if params[:bgcolor] == 'black'
    end
  end

  def redirect
    if @bookpage.pagenum.zero?
      redirect_to edit_book_path(@bookpage.book_id, razvorot: @bookpage.pagenum, rt: @bookpage.template)
    elsif @bookpage.pagenum.even?
      redirect_to edit_book_path(@bookpage.book_id, razvorot: (@bookpage.pagenum / 2.0).round,
                                                    lt: Bookpage.find(@bookpage.id - 1).template,
                                                    rt: @bookpage.template)
    else
      redirect_to edit_book_path(@bookpage.book_id, razvorot: (@bookpage.pagenum / 2.0).round,
                                                    lt: @bookpage.template,
                                                    rt: Bookpage.find(@bookpage.id + 1).template)
    end
  end

  def imagerotate
    i = params[:imagenum].to_i
    imageobject = @bookpage.phgallery.images.find { |image| image.url == @bookpage.images[i] }
    imagefile = Magick::Image.read(imageobject.ineditor.path).first
    imagefile.rotate!(params[:rotate].to_i).write(imageobject.ineditor.path)
    imagefile = Magick::Image.read(imageobject.path).first
    imagefile.rotate!(params[:rotate].to_i).write(imageobject.path)
    imageobject && imagefile.destroy!
    @bookpage.positions[i] = '0px 0px'
    @bookpage.save
  end

  def positionsupdate
    array = if @bookpage.positions.present?
              @bookpage.positions
            else
              []
            end
    array[move[:div_id].to_i] = move[:positions]
    @bookpage.update(positions: array)
  end

  def update
    positionsupdate if params[:dragimage_params].present?
    if params[:phgallery_params].present?
      imageupdate
    elsif params[:rotate].present?
      imagerotate
      respond_to do |format|
        format.js { render inline: 'location.reload();' }
      end
    elsif params[:template].present?
      templateupdate
      redirect
    elsif params[:bgcolor].present?
      bgcolorupdate
      redirect
    end
  end

  def destroy
    @bookpage.destroy
    redirect_to bookpages_url, notice: 'Bookpage was successfully destroyed.'
  end

  private

  def set_bookpage
    @bookpage = Bookpage.find(params[:id])
  end

  def bookpage_params
    params.require(:bookpage).permit(:positions, :template, :rotate, :imagenum,
                                     :bgcolor, :pagenum, :book_id, images: [])
  end

  def photo
    params.require(:phgallery_params).permit(:div_id, :photo_id)
  end

  def move
    params.require(:dragimage_params).permit(:div_id, :positions)
  end
end
