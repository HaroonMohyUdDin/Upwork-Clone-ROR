class CreateContracts < ActiveRecord::Migration[8.1]
  def change
    create_table :contracts do |t|
      # t.references AUTOMATICALLY creates indexes
      t.references :job, null: false, foreign_key: true
      t.references :proposal, null: false, foreign_key: true
      
      # These are just integers, so we need to add indexes
      t.integer :freelancer_id, null: false
      t.integer :client_id, null: false
      
      t.string :status, default: 'active'
      t.datetime :start_date
      t.datetime :end_date

      t.timestamps
    end

    # Only add indexes for columns that DON'T have them yet
    add_index :contracts, :freelancer_id
    add_index :contracts, :client_id
    add_index :contracts, :status
    # DON'T add indexes for :job_id or :proposal_id (already created by t.references)

    # Add foreign keys
    add_foreign_key :contracts, :users, column: :freelancer_id
    add_foreign_key :contracts, :users, column: :client_id
  end
end