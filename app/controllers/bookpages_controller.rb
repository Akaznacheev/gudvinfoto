class BookpagesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_bookpage, only: [:show, :edit, :update, :destroy]

  def index
    @bookpages = Bookpage.all
  end

  def show
  end

  def new
    @bookpage = Bookpage.new
  end

  def edit
  end

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
    imgchecks = @bookpage.book.phgallery.imgchecks
    if @bookpage.images[index].nil?
      imgchecks << dragphoto.url
    else
      puts '1'
      imgchecks = imgchecks - [@bookpage.images[index]]
      imgchecks << dragphoto.url
      puts imgchecks
    end
    @bookpage.book.phgallery.update(imgchecks: imgchecks)
    @bookpage.images[index] = dragphoto
    @bookpage.positions[index] = "0px 0px"
    @bookpage.save
  end

  def templateupdate
    template = params[:template].to_i
    case
      when template == 0
        @bookpage.update(:images=>[], :positions=>[], :template=> 0)
      when template == 10
        @bookpage.update(:images=>[], :positions=>[], :template=> 0)
        @bookpage2 = Bookpage.find(@bookpage.id + 1)
        @bookpage2.update(:images=>[], :positions=>[], :template=> 0)
      when template > 10
        @bookpage.update(:template => template)
        @bookpage2 = Bookpage.find(@bookpage.id + 1)
        @bookpage2.update(:images=>[], :positions=>[], :template=> 0)
      else
        @bookpage.update(:template => template)
        case @bookpage.pagenum == 0
          when @bookpage.template == 1
            @bookpage.book.update(:fontsize => 6)
          when @bookpage.template == 3
            @bookpage.book.update(:fontsize => 6)
          when @bookpage.template == 5
            @bookpage.book.update(:fontsize => 6)
          else
            @bookpage.book.update(:fontsize => 3)
        end
    end
  end

  def bgcolorupdate
    @bookpage.update(:bgcolor => params[:bgcolor])
    if @bookpage.pagenum == 0
      @book = Book.find(@bookpage.book_id)
      case
        when params[:bgcolor] == "white"
          @book.update(:fontcolor => "black")
        when params[:bgcolor] == "black"
          @book.update(:fontcolor => "white")
      end
    end
  end

  def redirect
    case
      when (@bookpage.pagenum) == 0
        redirect_to edit_book_path(@bookpage.book_id, :razvorot => @bookpage.pagenum, :rt => @bookpage.template)
      when (@bookpage.pagenum % 2) == 0
        redirect_to edit_book_path(@bookpage.book_id, :razvorot => (@bookpage.pagenum / 2.0).round, :lt => Bookpage.find(@bookpage.id - 1).template, :rt => @bookpage.template)
      else
        redirect_to edit_book_path(@bookpage.book_id, :razvorot => (@bookpage.pagenum / 2.0).round, :lt => @bookpage.template, :rt => Bookpage.find(@bookpage.id + 1).template)
    end
  end

  def imagerotate
    i = params[:imagenum].to_i
    imageobject = @bookpage.phgallery.images.find{ |image| image.url == @bookpage.images.first}
    imagefile = Magick::Image.read(imageobject.ineditor.path).first
    imagefile.rotate!(params[:rotate].to_i).write(imageobject.ineditor.path)
    imagefile = Magick::Image.read(imageobject.path).first
    imagefile.rotate!(params[:rotate].to_i).write(imageobject.path)
    imageobject && imagefile.destroy!
    @bookpage.positions[i] = "0px 0px"
    @bookpage.save
  end

  def positionsupdate
    if @bookpage.positions.present?
      array = @bookpage.positions
    else
      array = []
    end
    array[move[:div_id].to_i] = move[:positions]
    @bookpage.update(:positions => array)
  end

  def update
    if params[:dragimage_params].present?
      positionsupdate
    end
    if params[:phgallery_params].present?
      imageupdate
    else
      case
        when params[:rotate].present?
          imagerotate
          respond_to do |format|
            format.js {render inline: "location.reload();" }
          end
        when params[:template].present?
          templateupdate
          redirect
        when params[:bgcolor].present?
          bgcolorupdate
          redirect
      end
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
      params.require(:bookpage).permit(:positions, :template, :rotate, :imagenum, :bgcolor, :pagenum, :book_id, {images: []})
    end
    def photo
      params.require(:phgallery_params).permit(:div_id, :photo_id)
    end
    def move
      params.require(:dragimage_params).permit(:div_id, :positions)
    end

end
