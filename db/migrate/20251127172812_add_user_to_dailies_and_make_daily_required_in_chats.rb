class AddUserToDailiesAndMakeDailyRequiredInChats < ActiveRecord::Migration[7.1]
  def up
    # Step 1: Add user_id column as nullable to allow existing records
    add_column :dailies, :user_id, :bigint
    add_index :dailies, :user_id

    # Step 2: Backfill existing dailies with a user
    # Assign all existing dailies to the first user
    default_user = User.first

    # If no users exist, create a system/default user
    if default_user.nil?
      default_user = User.create!(
        email: 'system@example.com',
        password: SecureRandom.hex(20)
      )
      puts "Created default system user with ID: #{default_user.id}"
    end

    # Update all dailies without a user
    Daily.where(user_id: nil).update_all(user_id: default_user.id)
    puts "Assigned #{Daily.where(user_id: default_user.id).count} dailies to user #{default_user.email}"

    # Step 3: Now make user_id NOT NULL since all records have a user
    change_column_null :dailies, :user_id, false

    # Step 4: Add foreign key constraint
    add_foreign_key :dailies, :users

    # Step 5: Make daily_id required in chats
    change_column_null :chats, :daily_id, false
  end

  def down
    # Reverse the changes
    change_column_null :chats, :daily_id, true

    remove_foreign_key :dailies, :users
    change_column_null :dailies, :user_id, true
    remove_index :dailies, :user_id
    remove_column :dailies, :user_id
  end
end
