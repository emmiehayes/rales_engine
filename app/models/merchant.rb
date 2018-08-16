class Merchant < ApplicationRecord
  has_many :invoices
  has_many :items
  has_many :invoice_items, through: :invoices
  has_many :transactions, through: :invoices


  def self.most_revenue(limit = 3)
    select('merchants.*, SUM(invoice_items.quantity * invoice_items.unit_price) AS total_revenue')
      .joins(:transactions, :invoice_items)
      .except(transactions: {result: 'failed' })
      .group('merchants.id')
      .order('total_revenue DESC')
      .limit(limit)
  end

  
end
