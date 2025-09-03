class CreateScheduledRecipes < ActiveRecord::Migration[7.1]
  def change
    create_table :scheduled_recipes do |t|
      t.references :user, null: false, foreign_key: true
      t.references :recipe, null: false, foreign_key: true
      t.integer :day_of_week, null: false

      t.timestamps
    end

    add_index :scheduled_recipes, %i[user_id day_of_week], unique: true
  end
end
