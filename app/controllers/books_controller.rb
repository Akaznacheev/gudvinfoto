class BooksController < ApplicationController
  before_action :authenticate_user!
  before_action :set_book, only: [:show, :edit, :update, :destroy]

  def index
    @books = Book.all
  end

  def show
  end

  def new
    @book = Book.new
  end

  def edit
  end

  def create
    @book = Book.new(book_params)
    @book.save
    (0..Book::BPCOUNT).each do |i|
      @book.bookpages.create
      @book.bookpages[i].update(:pagenum => i)
    end
    @phgallery = Phgallery.new(book_id: @book.id)
    @phgallery.save
    @book.phgallery = @phgallery
    redirect_to edit_book_path(@book, :razvorot => 1, :lt => @book.bookpages[0].template, :rt => @book.bookpages[1].template)
  end

  def update
      if params[:cover_params].present?
        @book.update(:name => cover[:name],:fontsize => cover[:size], :fontfamily => cover[:family] )
      end
      nums = params[:addpages].to_i
      (1..nums).each do |i|
        prevpagenum = @book.bookpages.last.pagenum
        @book.bookpages.create(:pagenum => (prevpagenum + 1))
      end
      if params[:book].present?
        if @book.update(book_params)
          redirect_to book_path(@book, :razvorot => 1, :lt => @book.bookpages[0].template, :rt => @book.bookpages[1].template)
        else
          render :edit
        end
      else
        redirect_to edit_book_path(@book, :razvorot => (@book.bookpages.last.pagenum / 2.0).round, :lt => @book.bookpages[0].template, :rt => @book.bookpages[1].template)
      end
  end

  def destroy
    @book.destroy
    redirect_to books_url, notice: 'Book was successfully destroyed.'
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_book
      @book = Book.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def book_params
      params.require(:book).permit(:addpages, :phgallery, :pagecount, :user_id)
    end
    def cover
      params.require(:cover_params).permit(:family,:size,:name)
    end
end
