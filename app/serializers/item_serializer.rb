class ItemSerializer < ActiveModel::Serializer
  attributes :id, :name, :description, :unit_price, :merchant_id

  def unit_price
    '%.2f' % (object.unit_price/100.0)
  end
end
