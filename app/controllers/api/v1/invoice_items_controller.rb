class Api::V1::InvoiceItemsController < ApplicationController

  swagger_controller :invoice_items, "Invoice Items"

  swagger_api :index do
    summary 'Fetch all invoice items'
    response :ok
    response :unauthorized
    response :not_acceptable
    response :not_found
  end

  swagger_api :show do
    summary 'Fetch a single invoice item by passing the invoice item id'
    param :path, :id, :integer, :required, "Invoice Item Id"
    response :ok
    response :unauthorized
    response :not_acceptable
    response :not_found
  end

  def index
    render json: InvoiceItem.all
  end

  def show
    render json: InvoiceItem.find(params[:id])
  end
end
