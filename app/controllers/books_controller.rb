class BooksController < ApplicationController
  before_action :authenticate_user!
  before_action :set_book, only: [:show, :edit, :update, :destroy]

  def index
    @books = Book.all
    @book = Book.new
  end

  def show
    @order = Order.new
  end

  def new
    @book = Book.new
  end

  def edit
  end

  def create
    @bookprice = Bookprice.find_by_default("ПО УМОЛЧАНИЮ")
    @price = @bookprice.coverprice + @bookprice.twopageprice * (@bookprice.minpagescount)/2
    @book = Book.new(book_params)
    @book.save
    @book.update(:user_id => current_user.id, :bookprice_id => @bookprice.id, :price => @price)
    (0..@book.bookprice.minpagescount).each do |i|
      @book.bookpages.create
      @book.bookpages[i].update(:pagenum => i)
    end
    @book.bookpages.first.update(:template => 5)
    @phgallery = Phgallery.new(book_id: @book.id)
    @phgallery.save
    @book.phgallery = @phgallery
    redirect_to edit_book_path(@book, :razvorot => 0, :lt => @book.bookpages[0].template, :rt => @book.bookpages[1].template)
  end

  def update
    if params[:addpages].present?
      nums = params[:addpages].to_i
      (1..nums).each do |i|
        prevpagenum = @book.bookpages.last.pagenum
        @book.bookpages.create(:pagenum => (prevpagenum + 1))
        @price = @book.bookprice.coverprice + @book.bookprice.twopageprice * (@book.bookpages.count - 1)/2
        @book.update(:price => @price)
      end
    end
      if params[:cover_params].present?
        @book.update(:name => cover[:name],:fontsize => cover[:size], :fontfamily => cover[:family] )
      end
      if params[:bookprice].present?
        @bookprice = Bookprice.find_by_format(params[:bookprice])
        @price = @bookprice.coverprice + @bookprice.twopageprice * (@book.bookpages.count - 1)/2
        @book.update(:bookprice_id => @bookprice.id, :price => @price)

        redirect_to :back
      else
        if params[:book].present?
          if @book.update(book_params)
            redirect_to book_path(@book, :razvorot => 0, :lt => @book.bookpages[0].template, :rt => @book.bookpages[1].template)
          else
            render :edit
          end
        else
          redirect_to edit_book_path(@book, :razvorot => (@book.bookpages.last.pagenum / 2.0).round, :lt => @book.bookpages[0].template, :rt => @book.bookpages[1].template)
        end
      end
  end

  def destroy
    @book.destroy
    redirect_to books_url
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_book
      @book = Book.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def book_params
      params.require(:book).permit(:addpages, :phgallery, :user_id, :bookprice)
    end
    def cover
      params.require(:cover_params).permit(:family,:size,:name)
    end
end
