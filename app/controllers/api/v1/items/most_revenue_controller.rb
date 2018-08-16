class Api::V1::Items::MostRevenueController < ApplicationController

  def index 
    render json: Item.most_revenue(quantity_params[:quantity])
  end

  private

  def quantity_params
     params.permit(:quantity)
  end
end