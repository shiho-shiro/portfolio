class RemoveAdviseFromAdvices < ActiveRecord::Migration[6.1]
  def change
    remove_column :advices, :advise, :text
  end
end
