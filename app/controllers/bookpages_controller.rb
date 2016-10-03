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
    @images = []
    @photo = Book.find(@bookpage.book_id).phgallery.images[photo[:photo_id].to_i]
    @images << @photo
    @imagesfirsts = []
    @imageslasts = []
    Rails.logger.debug("My images: #{@imagesfirsts.inspect}")
    (1..(photo[:div_id].to_i - 1)).each do |i|
      if @bookpage.images[i-1].nil?
        @imagesfirsts << File.open(File.join(Rails.root, 'app','assets','images','lightgray.jpg'))
      else
        @imagesfirsts << @bookpage.images[i-1]
      end
    end
    ((photo[:div_id].to_i + 1)..14).each do |i|
      if @bookpage.images[i-1].nil?
        @imageslasts << File.open(File.join(Rails.root, 'app','assets','images','lightgray.jpg'))
      else
        @imageslasts << @bookpage.images[i-1]
      end
    end
    @images = @imagesfirsts + @images + @imageslasts
    @positionsfirsts = []
    @positionslasts = []
    @positions = ["0px 0px"]
    (1..(photo[:div_id].to_i - 1)).each do |i|
      if @bookpage.images[i-1].nil?
        @positionsfirsts << "0px 0px"
      else
        @positionsfirsts << @bookpage.positions[i-1]
      end
    end
    ((photo[:div_id].to_i + 1)..14).each do |i|
      if @bookpage.images[i-1].nil?
        @positionslasts << "0px 0px"
      else
        @positionslasts << @bookpage.positions[i-1]
      end
    end
    @positions = @positionsfirsts + @positions + @positionslasts
    @bookpage.update(:images => @images, :positions => @positions)
  end

  def templateupdate
    @bookpage.update(:template => params[:template])
    if @bookpage.template == 0
      @temp = @bookpage
      Rails.logger.debug("My images: #{@temp.inspect}")
      @bookpage.destroy
      Bookpage.create(:id => @temp.id, :template => @temp.template, :pagenum => @temp.pagenum, :created_at => @temp.created_at, :book_id => @temp.book_id)
    end
    if @bookpage.template == 10
      @bookpage2 = Bookpage.find(@bookpage.id + 1)
      @temp = @bookpage
      @temp2 = @bookpage2
      @bookpage.destroy
      @bookpage2.destroy
      Bookpage.create!(:id => @temp.id, :template => 0, :pagenum => @temp.pagenum, :created_at => @temp.created_at, :book_id => @temp.book_id)
      Bookpage.create!(:id => @temp2.id, :template => 0, :pagenum => @temp2.pagenum, :created_at => @temp2.created_at, :book_id => @temp2.book_id)
    end
    if @bookpage.template > 10
      @bookpage2 = Bookpage.find(@bookpage.id + 1)
      @bookpage2.update(:template => 0)
    end
  end

  def bgcolorupdate
    @bookpage.update(:bgcolor => params[:bgcolor])
    if @bookpage.pagenum == 0
      @book = Book.find(@bookpage.book_id)
      if params[:bgcolor] == "none"
        @book.update(:fontcolor => "black")
      end
      if params[:bgcolor] == "black"
        @book.update(:fontcolor => "white")
      end
    end
  end

  def redirect
    if (@bookpage.pagenum) == 0
      redirect_to edit_book_path(@bookpage.book_id, :razvorot => @bookpage.pagenum, :rt => @bookpage.template)
    else
      if (@bookpage.pagenum % 2) == 0
        redirect_to edit_book_path(@bookpage.book_id, :razvorot => (@bookpage.pagenum / 2.0).round, :lt => Bookpage.find(@bookpage.id - 1).template, :rt => @bookpage.template)
      else
        redirect_to edit_book_path(@bookpage.book_id, :razvorot => (@bookpage.pagenum / 2.0).round, :lt => @bookpage.template, :rt => Bookpage.find(@bookpage.id + 1).template)
      end
    end
  end

  def imagerotate
    @imageobject = @bookpage.images[params[:imagenum].to_i - 1]
    @imagefile = Magick::Image.read(@imageobject.file.file).first
    @imagefile.rotate(params[:rotate].to_i).write("public"+@imageobject.url)
    @positionsfirsts = []
    @positionslasts = []
    @positions = ["0px 0px"]
    (1..(params[:imagenum].to_i - 1)).each do |i|
      if @bookpage.images[i-1].nil?
        @positionsfirsts << "0px 0px"
      else
        @positionsfirsts << @bookpage.positions[i-1]
      end
    end
    ((params[:imagenum].to_i + 1)..14).each do |i|
      if @bookpage.images[i-1].nil?
        @positionslasts << "0px 0px"
      else
        @positionslasts << @bookpage.positions[i-1]
      end
    end
    @positions = @positionsfirsts + @positions + @positionslasts
    @bookpage.update(:positions => @positions)
  end

  def positionsupdate
    if @bookpage.positions.present?
      array = @bookpage.positions
    else
      array = []
    end
    array[move[:div_id].to_i - 1] = move[:positions]
    @bookpage.update(:positions => array)
  end

  def update
    if params[:dragimage_params].present?
      positionsupdate
    end
    if params[:phgallery_params].present?
      imageupdate
    else
      if params[:rotate].present?
        imagerotate
      end
      if params[:template].present?
        templateupdate
      end
      if params[:bgcolor].present?
        bgcolorupdate
      end
      redirect
    end
  end

  def destroy
    @bookpage.destroy
    redirect_to bookpages_url, notice: 'Bookpage was successfully destroyed.'
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_bookpage
      @bookpage = Bookpage.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
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
