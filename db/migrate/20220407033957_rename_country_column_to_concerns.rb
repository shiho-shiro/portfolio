class RenameCountryColumnToConcerns < ActiveRecord::Migration[6.1]
  def change
    rename_column :concerns, :country, :country_code
  end
end
