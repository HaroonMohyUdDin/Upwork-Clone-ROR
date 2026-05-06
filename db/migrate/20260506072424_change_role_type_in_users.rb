# db/migrate/[timestamp]_change_role_type_in_users.rb

class ChangeRoleTypeInUsers < ActiveRecord::Migration[8.1]
  def change
    # First, create a temporary column
    add_column :users, :role_int, :integer, default: 1
    
    # Copy data from old role to new column
    User.reset_column_information
    User.all.each do |user|
      case user.role
      when 'freelancer', nil
        user.update_column(:role_int, 0)
      when 'client'
        user.update_column(:role_int, 1)
      end
    end
    
    # Remove the old string column
    remove_column :users, :role
    
    # Rename the new column to role
    rename_column :users, :role_int, :role
  end
end
