class Api::V1::MerchantsController < ApplicationController
  
  swagger_controller :merchants, 'Merchants'
  
  swagger_api :index do
    summary 'Fetch all merchants'
    response :ok
    response :unauthorized
    response :not_acceptable
    response :not_found
  end

  swagger_api :show do
    summary 'Fetch a single merchant by passing the merchant\'s id'
    param :path, :id, :integer, :required, "Merchant Id"
    response :ok
    response :unauthorized
    response :not_acceptable
    response :not_found
  end

  def index
    render json: Merchant.all
  end

  def show
    render json: Merchant.find(params[:id])
  end
end
