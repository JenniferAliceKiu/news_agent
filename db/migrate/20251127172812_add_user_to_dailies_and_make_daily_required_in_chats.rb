class AddUserToDailiesAndMakeDailyRequiredInChats < ActiveRecord::Migration[7.1]
  def change
    # Add user_id column as nullable first to allow existing records
    add_reference :dailies, :user, null: true, foreign_key: true

    # Assign existing dailies to the first user (or create a default user if needed)
    reversible do |dir|
      dir.up do
        # Get the first user or create one if none exists
        default_user = User.first

        if default_user.nil?
          # If no users exist, create a system user
          default_user = User.create!(
            email: 'system@example.com',
            password: SecureRandom.hex(20)
          )
        end

        # Update all existing dailies to belong to this user
        Daily.where(user_id: nil).update_all(user_id: default_user.id)
      end
    end

    # Now make user_id NOT NULL since all records have a user
    change_column_null :dailies, :user_id, false

    # Make daily_id required in chats
    change_column_null :chats, :daily_id, false
  end
end
