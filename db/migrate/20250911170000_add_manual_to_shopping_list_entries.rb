class AddManualToShoppingListEntries < ActiveRecord::Migration[7.1]
  def change
    add_column :shopping_list_entries, :manual, :boolean, null: false, default: false
  end
end

