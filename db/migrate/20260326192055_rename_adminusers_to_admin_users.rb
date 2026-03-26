class RenameAdminusersToAdminUsers < ActiveRecord::Migration[7.2]
  def change
    rename_table :adminusers, :admin_users

    if index_name_exists?(:admin_users, "index_adminusers_on_email")
      rename_index :admin_users, "index_adminusers_on_email", "index_admin_users_on_email"
    end

    if index_name_exists?(:admin_users, "index_adminusers_on_reset_password_token")
      rename_index :admin_users, "index_adminusers_on_reset_password_token", "index_admin_users_on_reset_password_token"
    end
  end
end