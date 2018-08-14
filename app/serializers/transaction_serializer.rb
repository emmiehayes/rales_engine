class TransactionSerializer < ActiveModel::Serializer
  attributes :id, :invoice_id, :result, :credit_card_number
end
