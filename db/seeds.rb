require "json"
require "open-uri"
""
puts "Nettoyage de la base..."
Bookmark.destroy_all
List.destroy_all
Movie.destroy_all

puts "Chargement des films..."
url = "https://tmdb.lewagon.com/movie/top_rated"
movies_data = JSON.parse(URI.open(url).read)["results"]

movies_data.each do |movie|
  next if movie["overview"].blank?

  Movie.find_or_create_by!(title: movie["title"]) do |m|
    m.overview   = movie["overview"]
    m.poster_url = "https://image.tmdb.org/t/p/w500#{movie["poster_path"]}"
    m.rating     = movie["vote_average"]
  end
end

puts "#{Movie.count} films chargés."

puts "Création des listes..."
[ "À voir ce soir", "Films cultes", "En famille" ].each do |name|
  List.find_or_create_by!(name: name)
end

puts "#{List.count} listes créées."
