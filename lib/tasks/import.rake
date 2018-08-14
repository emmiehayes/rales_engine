require 'csv'

namespace :import do
  desc "TODO"
  task all: :environment do
    puts "Created:"
    CSV.foreach('./data/customers.csv', headers: true) do |row|
     Customer.create(row.to_h)
    end
    puts "#{Customer.count} Customers"

    CSV.foreach('./data/merchants.csv', headers: true) do |row|
     Merchant.create(row.to_h)
    end
    puts "#{Merchant.count} Merchants"

    CSV.foreach('./data/items.csv', headers: true) do |row|
     Item.create(row.to_h)
    end
    puts "#{Item.count} Items"

    CSV.foreach('./data/invoices.csv', headers: true) do |row|
     Invoice.create(row.to_h)
    end
    puts "#{Invoice.count} Invoices"

    CSV.foreach('./data/invoice_items.csv', headers: true) do |row|
     InvoiceItem.create(row.to_h)
    end
    puts "#{InvoiceItem.count} InvoiceItems"

    CSV.foreach('./data/transactions.csv', headers: true) do |row|
     Transaction.create(row.to_h)
    end
    puts "#{Transaction.count} Transactions"
    
  end
end
