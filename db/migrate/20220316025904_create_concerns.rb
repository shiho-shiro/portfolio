class CreateConcerns < ActiveRecord::Migration[6.1]
  def change
    create_table :concerns do |t|
      t.string :title
      t.text :content
      t.string :image
      t.integer :user_id

      t.timestamps
    end
  end
end
