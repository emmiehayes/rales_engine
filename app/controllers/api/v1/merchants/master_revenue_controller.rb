class Api::V1::Merchants::MasterRevenueController < ApplicationController

  def show
    render json: Merchant.master_revenue(date_params[:date]), serializer: MasterRevenueSerializer
  end

  private

  def date_params
    params.permit(:date)
  end
end
