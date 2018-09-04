class Api::V1::TransactionsController < ApplicationController

  swagger_controller :transactions, 'Transactions'
  
  swagger_api :index do
    summary 'Fetch all transactions'
    response :ok
    response :unauthorized
    response :not_acceptable
    response :not_found
  end

  swagger_api :show do
    summary 'Fetch a single transaction by passing the transaction id'
    param :path, :id, :integer, :required, "Transaction Id"
    response :ok
    response :unauthorized
    response :not_acceptable
    response :not_found
  end
  
  def index
    render json: Transaction.all
  end

  def show
    render json: Transaction.find(params[:id])
  end
end
