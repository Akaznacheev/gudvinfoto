class ChangesController < ApplicationController
  before_action :set_change, only: %i[show edit update destroy]
  before_action :user_admin?, only: %i[show edit update destroy]

  def index
    @changes_days = Change.all.group_by { |u| u.created_at.beginning_of_day }
  end

  def show; end

  def new
    @change = Change.new
  end

  def edit; end

  def create
    @change = Change.new(change_params)
    respond_to do |format|
      if @change.save
        format.html { redirect_to changes_path, notice: 'Change was successfully created.' }
        format.json { render :index, status: :created, location: @change }
      else
        format.html { render :new }
        format.json { render json: @change.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    if @change.update(change_params)
      redirect_to changes_path, notice: 'Change was successfully updated.'
    else
      render :edit
    end
  end

  def destroy
    @change.destroy
    respond_to do |format|
      format.html { redirect_to changes_url, notice: 'Change was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private

  def set_change
    @change = Change.find(params[:id])
  end

  def change_params
    params.require(:change).permit(:description, :kind)
  end

  def user_admin?
    unless current_user.present? && current_user.admin?
      flash[:error] = 'У вас нет доступа к этой странице.'
      redirect_to root_path
    end
  end
end
