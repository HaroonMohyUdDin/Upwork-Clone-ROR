class AddFreelancerProfileFieldsToUsers < ActiveRecord::Migration[8.1]
  def change
    add_column :users, :skills, :text
    add_column :users, :work_history, :text
    add_column :users, :employment_history, :text
    add_column :users, :certifications, :text
    add_column :users, :hours_per_week, :string
  end
end
