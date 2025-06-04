class AddColumnAdmToUser < ActiveRecord::Migration[8.0]
  def change
    add_column :users, :adm, :boolean
  end
end
