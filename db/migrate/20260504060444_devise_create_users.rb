# frozen_string_literal: true

class DeviseCreateUsers < ActiveRecord::Migration[8.1]
   def change
    create_table :users do |t|
      ## Database authenticatable (from Devise)
      t.string :email, null: false, default: ""
      t.string :encrypted_password, null: false, default: ""
      t.string :reset_password_token
      t.datetime :reset_password_sent_at
      t.datetime :remember_created_at

      ## Email confirmation
      t.string :confirmation_token
      t.datetime :confirmed_at
      t.datetime :confirmation_sent_at
      t.string :unconfirmed_email

      ## Custom fields for Upwork clone
      t.string :role, null: false                                  # 'admin', 'freelancer', or 'client'
      t.string :name, null: false                                  # User's full name
      t.text :bio                                                  # Bio/Description
      t.decimal :hourly_rate, precision: 8, scale: 2              # For freelancers only
      t.string :profile_picture                                    # Profile image (local path)
      t.datetime :email_confirmed_at                               # When email was confirmed

      t.timestamps  # created_at, updated_at
    end

    # Create indexes for database performance
    add_index :users, :email, unique: true
    add_index :users, :reset_password_token, unique: true
    add_index :users, :confirmation_token, unique: true
    add_index :users, :role  # Index role for quick lookup by type
  end
end
