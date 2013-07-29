class AddUsernameToSession < ActiveRecord::Migration
  def change
    add_column :sessions, :username, :string
  end
end
