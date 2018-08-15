class Api::V1::Customers::TransactionsController < ApplicationController

  def show 
    render json: Customer.find(params[:customer_id]).transactions
  end
end