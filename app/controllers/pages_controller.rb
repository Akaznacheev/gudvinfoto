class PagesController < ApplicationController
  def index
    @pages = Page.order('created_at DESC')
  end

  def show
    @page = Page.find(params[:id])
  end

  def new
    @page = Page.new
  end

  def create
    @page = Page.new(page_params)
    if @page.save
      redirect_to pages_path, notice: 'The article has been successfully created.'
    else
      render action: 'new'
    end
  end

  def edit
    @page = Page.find(params[:id])
  end

  def update
    @page = Page.find(params[:id])
    if @page.update_attributes(page_params)
      redirect_to pages_path, notice: 'The article has been successfully updated.'
    else
      render action: 'edit'
    end
  end

  private

  def page_params
    params.require(:page).permit(:title, :body)
  end
end
