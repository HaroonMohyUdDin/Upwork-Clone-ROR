class CreateMessages < ActiveRecord::Migration[8.1]
  def change
    create_table :messages do |t|
      t.integer :sender_id, null: false
      t.integer :receiver_id, null: false
      t.integer :conversation_id, null: false
      t.text :content, null: false
      t.boolean :read, default: false

      t.timestamps
    end

    add_index :messages, [:sender_id, :receiver_id]
    add_index :messages, :conversation_id

    add_foreign_key :messages, :users, column: :sender_id
    add_foreign_key :messages, :users, column: :receiver_id
    
    # ❌ DELETE THIS LINE:
    # add_foreign_key :messages, :conversations, column: :conversation_id
  end
end