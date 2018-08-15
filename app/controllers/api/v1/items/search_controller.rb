class Api::V1::Items::SearchController < ApplicationController
  def index
    render json: Item.where(search_params), each_serializer: SearchItemSerializer
  end

  def show
    render json: Item.all.order(:id).find_by(search_params), serializer: SearchItemSerializer
  end

  private

  def search_params
    params[:unit_price] = params[:unit_price].delete('.').to_i if params[:unit_price]
    params.permit(:id, :name, :description, :unit_price, :merchant_id, :created_at, :updated_at)
  end
end
