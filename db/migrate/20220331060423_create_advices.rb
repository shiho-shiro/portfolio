class CreateAdvices < ActiveRecord::Migration[6.1]
  def change
    create_table :advices do |t|
      t.text :advise
      t.integer :user_id
      t.integer :concern_id
      t.string :country

      t.timestamps
    end
  end
end
