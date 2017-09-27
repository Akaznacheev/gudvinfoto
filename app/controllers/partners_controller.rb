class PartnersController < ApplicationController
  before_action :set_partner, only: %i[show edit update destroy]

  def index
    @partners = Partner.all
  end

  def show; end

  private

  def set_partner
    @partner = Partner.find(params[:id])
  end
end
