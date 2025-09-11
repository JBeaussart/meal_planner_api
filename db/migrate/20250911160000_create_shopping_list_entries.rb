class CreateShoppingListEntries < ActiveRecord::Migration[7.1]
  def change
    create_table :shopping_list_entries do |t|
      t.references :user, null: false, foreign_key: true
      t.string :name, null: false
      t.string :unit
      t.string :normalized_name, null: false
      t.string :normalized_unit
      t.boolean :checked, null: false, default: false

      t.timestamps
    end

    add_index :shopping_list_entries, %i[user_id normalized_name normalized_unit], unique: true,
                                                                                   name: 'idx_shopping_entries_uniqueness'
  end
end
