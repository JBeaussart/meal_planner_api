class CreateSteps < ActiveRecord::Migration[7.1]
  def change
    create_table :steps do |t|
      t.integer :position
      t.text :description
      t.references :recipe, null: false, foreign_key: true
      t.references :category, foreign_key: true

      t.timestamps
    end
  end
end
