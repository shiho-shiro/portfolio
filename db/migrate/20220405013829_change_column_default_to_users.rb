class ChangeColumnDefaultToUsers < ActiveRecord::Migration[6.1]
  def change
    change_column_default :users, :country, from: nil, to: "JP"
  end
end
