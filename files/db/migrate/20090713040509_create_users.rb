class CreateUsers < ActiveRecord::Migration
  def self.up
    create_table :users do |t|
      t.string   :username, :email, :last_name, :first_name,
                 :openid_identifier,
                 :last_login_ip, :current_login_ip, :persistence_token

      t.boolean  :active, :default => true
      t.string   :crypted_password,    :limit => 128, :default => "", :null => true
      t.string   :password_salt,       :limit => 128, :default => "", :null => true

      t.string   :single_access_token,                :default => "", :null => false
      t.integer  :login_count,                        :default => 0,  :null => false
      t.integer  :failed_login_count,                 :default => 0,  :null => false
      t.datetime :last_request_at, :last_login_at, :current_login_at
      t.timestamps
    end

    create_table "roles", :force => true do |t|
      t.string  "name"
      t.string  "authorizable_type", :limit => 40
      t.integer "authorizable_id"
    end

    create_table "roles_users", :id => false, :force => true do |t|
      t.integer "role_id"
      t.integer "user_id"
    end

    add_index "roles_users", ["role_id"], :name => "index_roles_users_on_role_id"
    add_index "roles_users", ["user_id"], :name => "index_roles_users_on_user_id"

    add_index :users, :openid_identifier

    add_index "users", ["username"], :name => "index_users_on_username"
    add_index "users", ["persistence_token"], :name => "index_users_on_remember_token"

    User.reset_column_information
    Role.reset_column_information

  end

  def self.down
  end
end
