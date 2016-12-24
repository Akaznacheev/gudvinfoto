class BooksController < ApplicationController
  before_action :authenticate_user!
  before_action :set_book, only: [:show, :edit, :update, :destroy]

  def index
    @books = Book.all
    @book = Book.new
  end

  def show
  end

  def new
    @book = Book.new
  end

  def edit
  end

  def create
    @bookprice = Bookprice.find_by_default("ПО УМОЛЧАНИЮ")
    @price = @bookprice.coverprice + @bookprice.twopageprice * (@bookprice.minpagescount)/2
    @book = Book.create(book_params)
    @book.update(:user_id => current_user.id, :bookprice_id => @bookprice.id, :price => @price)
    (0..@book.bookprice.minpagescount).each do |i|
      @book.bookpages.create(:pagenum => i)
    end
    @book.bookpages.first.update(:template => 5)
    @book.phgallery = Phgallery.create(book_id: @book.id)
    @book.bookprice = @bookprice
    orderdayid = Order.where("created_at >= ?", Time.zone.now.beginning_of_day).count + 1
    if orderdayid < 10
      @name = Time.now.strftime("%d-%m-%Y-") + "000" + orderdayid.to_s
    elsif orderdayid < 100
      @name = Time.now.strftime("%d-%m-%Y-") + "00" + orderdayid.to_s
    elsif orderdayid < 1000
      @name = Time.now.strftime("%d-%m-%Y-") + "0" + orderdayid.to_s
    else
      @name = Time.now.strftime("%d-%m-%Y-") + orderdayid.to_s
    end
    @book.order = Order.create(:name => @name, :bookscount => 1, :fio => current_user.name, :email => current_user.email, :price => @book.price, :delivery_id => 1)
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
    def set_book
      @book = Book.find(params[:id])
    end
    def book_params
      params.require(:book).permit(:addpages, :phgallery, :user_id, :bookprice, :order, :created_at)
    end
    def cover
      params.require(:cover_params).permit(:family,:size,:name)
    end
end
