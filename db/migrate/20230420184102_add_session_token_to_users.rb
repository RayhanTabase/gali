class AddSessionTokenToUsers < ActiveRecord::Migration[7.0]
  def change
    add_column :users, :session_token, :string
    add_column :users, :session_token_expiry, :datetime
  end
end
