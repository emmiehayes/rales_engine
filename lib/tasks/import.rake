require 'csv'

namespace :import do
  desc "TODO"
  task all: :environment do
    CSV.foreach('./data/merchants.csv', headers: true) do |row|
     Merchant.create(row.to_h)
    end
  end
end
