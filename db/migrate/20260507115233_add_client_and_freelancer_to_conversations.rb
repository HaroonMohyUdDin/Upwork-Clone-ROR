class AddClientAndFreelancerToConversations < ActiveRecord::Migration[8.1]
  def change
    add_reference :conversations, :client, null: false, foreign_key: { to_table: :users }
    add_reference :conversations, :freelancer, null: false, foreign_key: { to_table: :users }

    add_index :conversations, [:client_id, :freelancer_id], unique: true
  end
end