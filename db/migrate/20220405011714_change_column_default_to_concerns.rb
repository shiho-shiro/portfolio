class ChangeColumnDefaultToConcerns < ActiveRecord::Migration[6.1]
  def change
    change_column_default :concerns, :country, from: nil, to: "JP"
  end
end
