require 'pathname'

# Supprime toutes les recettes (ingrédients et étapes en dépendance)
Recipe.destroy_all
puts 'Toutes les recettes existantes ont été supprimées'
puts '--------------------'

# S'assure qu'un utilisateur existe pour associer les recettes
user = User.first || User.create!(email: 'demo@example.com', password: 'password')

recipes_md_path = Pathname.new(__dir__).join('..', 'recipes.md').cleanpath

def parse_quantity_and_unit(raw)
  return [nil, nil] if raw.nil?

  s = raw.strip
  # Extrait un entier au début, si présent
  if (m = s.match(/^(\d+)/))
    qty = m[1].to_i
    unit = s[m[0].length..]&.strip
    unit = nil if unit == ''
    [qty, unit]
  else
    [nil, s == '' ? nil : s]
  end
end

def parse_recipes_markdown(text)
  recipes = []
  current = nil
  section = nil

  text.each_line do |line|
    l = line.strip
    next if l.empty?

    if l.start_with?('titre:')
      # Sauvegarde la recette précédente si existante
      recipes << current if current
      title = l.sub(/^titre:\s*/i, '')
      current = { title: title, ingredients: [], steps: [] }
      section = nil
      next
    end

    if l.downcase.start_with?('ingredients:')
      section = :ingredients
      next
    end

    if l.downcase.start_with?('steps:') || l.downcase.start_with?('etapes:')
      section = :steps
      next
    end

    # bullets "- ..."
    next unless l.start_with?('- ')

    item = l[2..]
    case section
    when :ingredients
      name, rest = item.split(':', 2)
      name = name.to_s.strip
      qty, unit = parse_quantity_and_unit(rest)
      current[:ingredients] << { name: name, quantity: qty, unit: unit }
    when :steps
      current[:steps] << item.strip
    end
  end

  recipes << current if current
  recipes
end

unless recipes_md_path.file?
  puts "Fichier recipes.md introuvable: #{recipes_md_path}"
  exit 1
end

md_content = File.read(recipes_md_path)
parsed = parse_recipes_markdown(md_content)

if parsed.empty?
  puts 'Aucune recette trouvée dans recipes.md'
else
  parsed.each do |r|
    recipe = Recipe.create!(title: r[:title], user: user)

    r[:steps].each_with_index do |desc, idx|
      recipe.steps.create!(position: idx + 1, description: desc)
    end

    r[:ingredients].each do |ing|
      recipe.ingredients.create!(name: ing[:name], quantity: ing[:quantity], unit: ing[:unit])
    end

    puts "Recette créée: #{recipe.title} (#{recipe.ingredients.size} ingrédients, #{recipe.steps.size} étapes)"
  end
end

puts 'Seed terminé.'
