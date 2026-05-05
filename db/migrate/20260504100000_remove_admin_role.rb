class RemoveAdminRole < ActiveRecord::Migration[8.0]
  def up
    # Convert any admin users to client role
    # In Rails enums, the string keys are stored in the database
    execute "UPDATE users SET role = 'client' WHERE role = 'admin'"
  end

  def down
    # Rollback not possible as enum structure changed
    # This is a one-way migration
  end
end
