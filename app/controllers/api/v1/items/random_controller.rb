class Api::V1::Items::RandomController < ApplicationController
  def show
    render json: Item.order("RANDOM()").first
  end
end
