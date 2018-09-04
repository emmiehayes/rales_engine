class Api::V1::ItemsController < ApplicationController

  swagger_controller :items, 'Items'
  
  swagger_api :index do
    summary 'Fetch all items'
    response :ok
    response :unauthorized
    response :not_acceptable
    response :not_found
  end

  swagger_api :show do
    summary 'Fetch a single item by passing the item id'
    param :path, :id, :integer, :required, "Item Id"
    response :ok
    response :unauthorized
    response :not_acceptable
    response :not_found
  end
  
  def index
    render json: Item.all
  end

  def show
    render json: Item.find(params[:id])
  end
end
