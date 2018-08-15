class Transaction < ApplicationRecord
  belongs_to :invoice
  has_one :customer, through: :invoices
end
