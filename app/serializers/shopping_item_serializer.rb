class ShoppingItemSerializer
  include JSONAPI::Serializer

  set_type :shopping_item
  attributes :name, :quantity, :unit, :checked, :deletable
end
