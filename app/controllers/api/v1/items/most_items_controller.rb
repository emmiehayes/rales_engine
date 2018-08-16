class Api::V1::Items::MostItemsController < ApplicationController

  def show
    render json: Item.most_sold(quantity_params[:quantity])
  end

  private

  def quantity_params
    params.permit(:quantity)
  end
end
