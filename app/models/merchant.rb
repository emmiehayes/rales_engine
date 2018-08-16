class Merchant < ApplicationRecord
  has_many :invoices
  has_many :items
  has_many :invoice_items, through: :invoices
  has_many :transactions, through: :invoices
  has_many :customers, through: :invoices

  def self.most_revenue(limit = 3)
    select('merchants.*, SUM(invoice_items.quantity * invoice_items.unit_price) AS total_revenue')
      .joins(:transactions, :invoice_items)
      .except(transactions: { result: 'failed' })
      .group('merchants.id')
      .order('total_revenue DESC')
      .limit(limit)
  end

  def favorite_customer
    customers.select('customers.*, COUNT(invoices.id) AS invoice_count')
      .joins(:transactions)
      .where(transactions: {result: 'success'})
      .group(:id)
      .order('invoice_count DESC')
      .limit(1)
      .first
  end 

  def total_revenue
    invoices
      .joins(:transactions, :invoice_items)
      .where(transactions: {result: 'success'})
      .sum("invoice_items.quantity*invoice_items.unit_price")
  end
end