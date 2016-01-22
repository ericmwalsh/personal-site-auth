class AddAuthenticationTokenToAdmins < ActiveRecord::Migration
  def change
    add_column :admins, :authentication_token, :string, null: false, default: ""
  end
end
