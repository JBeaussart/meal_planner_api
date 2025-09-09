require 'faker'

# Delete all Recipes, Ingredients and Steps
Recipe.destroy_all
puts 'All Recipe destroyed'
puts '--------------------'

20.times do
  recipe = Recipe.create!(
    title: Faker::Food.dish,
    user: User.all.sample
  )

  rand(3..6).times do |i|
    recipe.steps.create!(
      position: i + 1,
      description: Faker::Restaurant.description
    )
  end

  rand(4..8).times do |_|
    recipe.ingredients.create!(
      name: Faker::Food.ingredient,
      quantity: rand(5..30),
      unit: %w[gr cl pièces].sample
    )
  end

  puts "Recipe #{recipe.title} created"
end
