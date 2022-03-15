class CreateMemories < ActiveRecord::Migration[6.1]
  def change
    create_table :memories do |t|
      t.string :title
      t.text :content
      t.date :date
      t.string :image
      t.integer :user_id

      t.timestamps
    end
  end
end
