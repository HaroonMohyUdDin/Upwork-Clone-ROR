class CreateJobs < ActiveRecord::Migration[8.1]
  def change
    create_table :jobs do |t|
      t.references :user, null: false, foreign_key: true
      t.string :title
      t.text :description
      t.decimal :budget
      t.string :category
      t.datetime :deadline
      t.string :status

      t.timestamps
    end
  end
end
