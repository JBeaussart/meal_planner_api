class AddQuantityToShoppingListEntries < ActiveRecord::Migration[7.1]
  def change
    add_column :shopping_list_entries, :quantity, :integer
  end
end

