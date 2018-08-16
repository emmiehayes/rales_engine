class Api::V1::InvoiceItems::RandomController < ApplicationController
  def show
    render json: InvoiceItem.order("RANDOM()").first
  end
end
