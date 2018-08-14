class TransactionSerializer < ActiveModel::Serializer
  attributes :id, :invoice_id, :result
end
