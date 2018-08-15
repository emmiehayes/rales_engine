class Api::V1::Merchants::MostRevenueController < ApplicationController

  def index 
    render json: Merchant.most_revenue(quantity_params[:quantity])
  end

  private

  def quantity_params
     params.permit(:quantity)
  end
end