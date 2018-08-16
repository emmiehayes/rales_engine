class Api::V1::Merchants::TotalRevenueController < ApplicationController
  def show
    render json: Merchant.find(params[:merchant_id]).total_revenue(total_revenue_params[:date]), serializer: TotalRevenueSerializer
  end

  private

  def total_revenue_params
    params.permit(:date)
  end
end
