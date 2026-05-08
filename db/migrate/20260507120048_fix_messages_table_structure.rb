class FixMessagesTableStructure < ActiveRecord::Migration[8.1]
  def change
    rename_column :messages, :content, :body
    remove_column :messages, :receiver_id, :integer
  end
end
