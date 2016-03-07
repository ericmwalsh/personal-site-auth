class ChangeAdminToStiUsers < ActiveRecord::Migration
  def change
    rename_table :admins, :users
    add_column :users, :type, :string, default: "Client"
  end
end
