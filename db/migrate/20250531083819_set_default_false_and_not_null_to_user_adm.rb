class SetDefaultFalseAndNotNullToUserAdm < ActiveRecord::Migration[8.0]
  def change
    change_column_default :users, :adm, from: nil, to: false
    change_column_null :users, :adm, false
  end
end
