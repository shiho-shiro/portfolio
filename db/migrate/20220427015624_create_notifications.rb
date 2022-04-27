class CreateNotifications < ActiveRecord::Migration[6.1]
  def change
    create_table :notifications do |t|
      t.integer :visitor_id
      t.integer :visited_id
      t.integer :concern_id
      t.integer :advice_id
      t.integer :recommend_id
      t.string :action
      t.boolean :checked, default: false, null: false

      t.timestamps
    end
  end
end
