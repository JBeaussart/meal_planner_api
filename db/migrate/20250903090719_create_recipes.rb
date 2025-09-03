class CreateRecipes < ActiveRecord::Migration[7.1]
  def change
    create_table :recipes do |t|
      t.string :title, null: false
      t.boolean :made_by_mom, default: false
      t.integer :taste, default: 0

      t.timestamps
    end
  end
end
