class Api::V1::Merchants::MostItemsController < ApplicationController

  def show
    render json: Merchant.most_sold(quantity_params[:quantity])
  end

  private

  def quantity_params
    params.permit(:quantity)
  end
end
