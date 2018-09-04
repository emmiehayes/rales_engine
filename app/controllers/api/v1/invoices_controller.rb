class Api::V1::InvoicesController < ApplicationController
  
  swagger_controller :invoices, 'Invoices'
  
  swagger_api :index do
    summary 'Fetch all invoices'
    response :ok
    response :unauthorized
    response :not_acceptable
    response :not_found
  end

  swagger_api :show do
    summary 'Fetch a single invoice by passing the invoice id'
    param :path, :id, :integer, :required, "Invoice Id"
    response :ok
    response :unauthorized
    response :not_acceptable
    response :not_found
  end
  
  def index
    render json: Invoice.all
  end

  def show
    render json: Invoice.find(params[:id])
  end
end
