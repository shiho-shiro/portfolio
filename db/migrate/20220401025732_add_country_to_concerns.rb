class AddCountryToConcerns < ActiveRecord::Migration[6.1]
  def change
    add_column :concerns, :country, :string
  end
end
