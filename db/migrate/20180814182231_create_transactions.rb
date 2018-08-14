class CreateTransactions < ActiveRecord::Migration[5.1]
  def change
    create_table :transactions do |t|
      t.references :invoice, foreign_key: true
      t.integer :credit_card_number
      t.datetime :credit_card_expiration
      t.string :result

      t.timestamps
    end
  end
end
