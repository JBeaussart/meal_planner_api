module Api
  module V1
    class ShoppingListsController < ApplicationController
      before_action :authenticate_api_v1_user!

      # GET /api/v1/shopping_list
      # Aggregates ingredients across the user's scheduled recipes
      def index
        scheduled = current_api_v1_user
                      .scheduled_recipes
                      .includes(recipe: :ingredients)

        grouped = {}

        scheduled.each do |sr|
          sr.recipe.ingredients.each do |ing|
            key_name = (ing.name || '').strip
            key_unit = (ing.unit || nil)&.strip
            key = [key_name.downcase, key_unit&.downcase]

            grouped[key] ||= { name: key_name, unit: key_unit, quantity: 0, all_nil: true }
            if ing.quantity.present?
              grouped[key][:quantity] += ing.quantity.to_i
              grouped[key][:all_nil] = false
            end
          end
        end

        # Load all persisted entries for the user (custom items + checked states)
        entries_by_key = {}
        current_api_v1_user.shopping_list_entries.find_each do |e|
          entries_by_key[[e.normalized_name, e.normalized_unit]] = e
        end

        # Merge entries (extras) into grouped quantities and add missing ones
        entries_by_key.each do |(n_name, n_unit), entry|
          key = [n_name, n_unit]
          if grouped[key]
            if entry.quantity.present?
              grouped[key][:quantity] = (grouped[key][:quantity] || 0) + entry.quantity.to_i
              grouped[key][:all_nil] = false if entry.quantity.to_i > 0
            end
          else
            grouped[key] = {
              name: entry.name.to_s,
              unit: entry.unit,
              quantity: entry.quantity.to_i,
              all_nil: entry.quantity.blank? || entry.quantity.to_i == 0
            }
          end
        end

        items = grouped.map do |(norm_name, norm_unit), data|
          qty = data[:all_nil] || data[:quantity].to_i == 0 ? nil : data[:quantity]
          entry_for_key = entries_by_key[[norm_name, norm_unit]]
          checked = entry_for_key&.checked || false
          deletable = entry_for_key&.manual ? true : false
          ShoppingItem.new(
            id: [data[:name], data[:unit]].compact.join('::'),
            name: data[:name],
            quantity: qty,
            unit: data[:unit],
            checked: checked,
            deletable: deletable
          )
        end

        # Sort by name for stable UI
        items.sort_by! { |i| i.name.downcase }

        render json: ShoppingItemSerializer.new(items).serializable_hash
      end

      # POST /api/v1/shopping_list/check
      # Params: { name: string, unit: string|null, checked: boolean }
      def check
        name = params[:name].to_s
        unit = params.key?(:unit) ? params[:unit] : nil
        checked = ActiveModel::Type::Boolean.new.cast(params[:checked])
        if name.blank?
          return render json: { errors: ['name is required'] }, status: :unprocessable_entity
        end

        norm_name = ShoppingListEntry.normalize_value(name)
        norm_unit = ShoppingListEntry.normalize_value(unit)

        entry = ShoppingListEntry.find_or_initialize_by(
          user_id: current_api_v1_user.id,
          normalized_name: norm_name,
          normalized_unit: norm_unit
        )
        entry.name = name
        entry.unit = unit
        entry.checked = checked
        entry.manual = false
        if entry.save
          head :no_content
        else
          render json: { errors: entry.errors.full_messages }, status: :unprocessable_entity
        end
      end

      # POST /api/v1/shopping_list
      # Params: { name: string, unit?: string|null, quantity?: integer }
      def create
        name = params[:name].to_s
        unit = params.key?(:unit) ? params[:unit] : nil
        quantity = params[:quantity]
        if name.blank?
          return render json: { errors: ['name is required'] }, status: :unprocessable_entity
        end

        norm_name = ShoppingListEntry.normalize_value(name)
        norm_unit = ShoppingListEntry.normalize_value(unit)

        entry = ShoppingListEntry.find_or_initialize_by(
          user_id: current_api_v1_user.id,
          normalized_name: norm_name,
          normalized_unit: norm_unit
        )
        entry.name = name
        entry.unit = unit
        entry.quantity = quantity.present? ? quantity.to_i : entry.quantity
        entry.checked = false if entry.new_record?
        entry.manual = true

        if entry.save
          # Return the current list item representation
          item = ShoppingItem.new(
            id: [entry.name, entry.unit].compact.join('::'),
            name: entry.name,
            quantity: entry.quantity,
            unit: entry.unit,
            checked: entry.checked
          )
          render json: ShoppingItemSerializer.new(item).serializable_hash, status: :created
        else
          render json: { errors: entry.errors.full_messages }, status: :unprocessable_entity
        end
      end

      # DELETE /api/v1/shopping_list
      # Params: { name: string, unit?: string|null }
      def destroy
        name = params[:name].to_s
        unit = params.key?(:unit) ? params[:unit] : nil
        if name.blank?
          return render json: { errors: ['name is required'] }, status: :unprocessable_entity
        end

        norm_name = ShoppingListEntry.normalize_value(name)
        norm_unit = ShoppingListEntry.normalize_value(unit)

        entry = ShoppingListEntry.find_by(
          user_id: current_api_v1_user.id,
          normalized_name: norm_name,
          normalized_unit: norm_unit,
          manual: true
        )
        return head :not_found unless entry

        entry.destroy
        head :no_content
      end
    end
  end
end
