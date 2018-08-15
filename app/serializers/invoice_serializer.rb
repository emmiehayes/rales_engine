class InvoiceSerializer < ActiveModel::Serializer
  attributes :id, :status, :merchant_id, :customer_id
end
