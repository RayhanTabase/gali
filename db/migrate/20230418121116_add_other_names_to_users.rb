class AddOtherNamesToUsers < ActiveRecord::Migration[7.0]
  def change
    add_column :users, :other_names, :string
  end
end
