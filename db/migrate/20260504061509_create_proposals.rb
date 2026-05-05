class CreateProposals < ActiveRecord::Migration[8.1]
  def change
    create_table :proposals do |t|
      t.references :job, null: false, foreign_key: true
      t.references :user, null: false, foreign_key: true
      t.text :cover_letter
      t.string :status

      t.timestamps
    end
     # Ensure one proposal per freelancer per job
    add_index :proposals, [:job_id, :user_id], unique: true
    add_index :proposals, :status
  end
end
