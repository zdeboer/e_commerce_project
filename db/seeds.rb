require "net/http"
require "json"

puts "Clearing old data..."
Genre.destroy_all
MediaType.destroy_all
Product.destroy_all
ProductVariation.destroy_all
Inventory.destroy_all

puts "Creating media types..."
media_types = {
  dvd: MediaType.create!(name: "DVD"),
  bluray: MediaType.create!(name: "Blu-ray"),
  vhs: MediaType.create!(name: "VHS"),
  vinyl: MediaType.create!(name: "Vinyl"),
  cd: MediaType.create!(name: "CD")
}

puts "Creating genres..."
movie_genres = {}
music_genres = {}

# TMDb API setup
TMDB_API_KEY = ENV["TMDB_API_KEY"]
TMDB_BASE = "https://api.themoviedb.org/3"
TMDB_IMG = "https://image.tmdb.org/t/p/w500"

def tmdb(path)
  url = URI("#{TMDB_BASE}#{path}?api_key=#{TMDB_API_KEY}")
  JSON.parse(Net::HTTP.get(url))
end

puts "Importing movies from TMDb..."

movie_ids = [27205, 155, 157336] # Inception, TDK, Interstellar

movie_ids.each do |id|
  data = tmdb("/movie/#{id}")

  # Create genre if missing
  genre_name = data["genres"].first["name"]
  genre = Genre.find_or_create_by!(name: genre_name)

  product = Product.create!(
    name: data["title"],
    description: data["overview"],
    price: rand(10..30),
    sku: "MOV-#{id}",
    genre: genre,
    media_type: media_types[:bluray],
    image_url: "#{TMDB_IMG}#{data["poster_path"]}"
  )

  # Variations
  ["DVD", "Blu-ray", "VHS"].each do |format|
    variation = ProductVariation.create!(
      product: product,
      variation_name: "Format",
      variation_value: format
    )

    Inventory.create!(
      product_variation: variation,
      quantity: rand(5..20),
      last_updated: Time.now
    )
  end
end

puts "Movies imported."

# MusicBrainz + Cover Art Archive
puts "Importing music albums..."

albums = {
  "Dark Side of the Moon" => "83d91898-7763-47d7-b03b-b92132375c47",
  "Abbey Road" => "c3cceeed-3332-4cf0-8c4c-bbde425147b6"
}

albums.each do |title, mbid|
  # Fetch album metadata
  url = URI("https://musicbrainz.org/ws/2/release-group/#{mbid}?fmt=json")
  data = JSON.parse(Net::HTTP.get(url))

  # Fetch cover art
  cover_url = "https://coverartarchive.org/release-group/#{mbid}/front"

  genre = Genre.find_or_create_by!(name: "Music")

  product = Product.create!(
    name: data["title"],
    description: "Music album: #{data["title"]}",
    price: rand(15..40),
    sku: "ALB-#{mbid[0..5]}",
    genre: genre,
    media_type: media_types[:vinyl],
    image_url: cover_url
  )

  ["Vinyl", "CD"].each do |format|
    variation = ProductVariation.create!(
      product: product,
      variation_name: "Format",
      variation_value: format
    )

    Inventory.create!(
      product_variation: variation,
      quantity: rand(3..15),
      last_updated: Time.now
    )
  end
end

puts "Music imported."
puts "Seeding complete!"