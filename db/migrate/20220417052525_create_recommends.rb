class CreateRecommends < ActiveRecord::Migration[6.1]
  def change
    create_table :recommends do |t|
      t.string :title
      t.string :content
      t.string :image
      t.string :country_code, default: "JP"
      t.integer :user_id
      t.string :address
      t.float :latitude
      t.float :longitude

      t.timestamps
    end
  end
end
