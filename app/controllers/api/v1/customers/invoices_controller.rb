class Api::V1::Customers::InvoicesController < ApplicationController
  def show 
    render json: Customer.find(params[:customer_id]).invoices
  end
end

