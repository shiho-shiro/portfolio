class RemoveCountryFromAdvices < ActiveRecord::Migration[6.1]
  def change
    remove_column :advices, :country, :string
  end
end
