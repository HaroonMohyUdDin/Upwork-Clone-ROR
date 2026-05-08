class CreateConversations < ActiveRecord::Migration[8.1]
  def change
    create_table :conversations do |t|
      t.references :client, null: false, foreign_key: { to_table: :users }
      t.references :freelancer, null: false, foreign_key: { to_table: :users }

      t.timestamps
    end

    add_index :conversations, [:client_id, :freelancer_id], unique: true
  end
end