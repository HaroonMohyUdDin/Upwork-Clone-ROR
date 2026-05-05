class CreatePayments < ActiveRecord::Migration[8.1]
  def change
    create_table :payments do |t|
      t.references :user, null: false, foreign_key: true
      t.references :job, null: false, foreign_key: true
      t.decimal :amount, precision: 10, scale: 2, null: false
      t.string :status, default: 'pending'
      t.datetime :payment_date
      t.text :description

      t.timestamps
    end

    # DON'T add indexes for :user_id or :job_id (already created by t.references)
    # But you CAN add index for :status if you want
    add_index :payments, :status
  end
end