class CreateConversations < ActiveRecord::Migration[8.1]
  def change
    create_table :conversations do |t|
      t.integer :sender_id, null: false
      t.integer :receiver_id, null: false

      t.timestamps
    end

    # Add indexes for integer columns
    add_index :conversations, [:sender_id, :receiver_id], unique: true

    add_foreign_key :conversations, :users, column: :sender_id
    add_foreign_key :conversations, :users, column: :receiver_id
  end
end