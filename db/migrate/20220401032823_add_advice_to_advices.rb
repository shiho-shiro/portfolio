class AddAdviceToAdvices < ActiveRecord::Migration[6.1]
  def change
    add_column :advices, :advice, :text
  end
end
