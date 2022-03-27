class DropTableAdvices < ActiveRecord::Migration[6.1]
  def change
    drop_table :advices
  end
end
