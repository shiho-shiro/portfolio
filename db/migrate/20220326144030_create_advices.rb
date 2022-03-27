class CreateAdvices < ActiveRecord::Migration[6.1]
  def change
    create_table :advices do |t|
      t.text :advice
      t.integer :user_id
      t.integer :concern_id

      t.timestamps
    end
  end
end
