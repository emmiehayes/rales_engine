class Api::V1::CustomersController < ApplicationController

  swagger_controller :customers, "Customers"

  swagger_api :index do
    summary 'Fetch all customers'
    response :ok
    response :unauthorized
    response :not_acceptable
    response :not_found
  end

  swagger_api :show do
    summary 'Fetch a single customer by passing the customer\'s id'
    param :path, :id, :integer, :required, "Customer Id"
    response :ok
    response :unauthorized
    response :not_acceptable
    response :not_found
  end

  def index
    render json: Customer.all
  end

  def show
    render json: Customer.find(params[:id])
  end
end
