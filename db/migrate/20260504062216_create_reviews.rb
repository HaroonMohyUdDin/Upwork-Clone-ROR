class CreateReviews < ActiveRecord::Migration[8.1]
  def change
    create_table :reviews do |t|
      t.integer :reviewer_id, null: false
      t.integer :reviewee_id, null: false
      t.references :job, null: false, foreign_key: true
      t.integer :rating, null: false
      t.text :comment

      t.timestamps
    end

    # Only add indexes for integer columns (not t.references)
    add_index :reviews, [:reviewer_id, :reviewee_id, :job_id], unique: true
    # DON'T add index for :job_id alone (it's already in the composite index above)

    add_foreign_key :reviews, :users, column: :reviewer_id
    add_foreign_key :reviews, :users, column: :reviewee_id
  end
end
