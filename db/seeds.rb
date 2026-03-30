require "net/http"
require "json"

def http_get_json(uri, headers: {})
  http = Net::HTTP.new(uri.host, uri.port)
  http.use_ssl = uri.scheme == "https"
  http.open_timeout = 5
  http.read_timeout = 10

  req = Net::HTTP::Get.new(uri)
  headers.each { |k, v| req[k] = v }

  res = http.request(req)
  return nil unless res.is_a?(Net::HTTPSuccess)

  JSON.parse(res.body)
rescue JSON::ParserError, SocketError, Net::OpenTimeout, Net::ReadTimeout, Errno::ECONNREFUSED
  nil
end

puts "Clearing old data..."

# Must delete in correct order due to foreign keys
OrderItem.destroy_all
Order.destroy_all
Inventory.destroy_all
ProductVariation.destroy_all
Product.destroy_all
Genre.destroy_all
MediaType.destroy_all
Address.destroy_all
Customer.destroy_all
AdminUser.destroy_all

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

puts "Creating demo admin + customer..."
AdminUser.create!(
  email: "zackdb2005@gmail.com",
  password: "AlphaArrow77*",
  password_confirmation: "AlphaArrow77*"
)

demo_customer = Customer.create!(
  first_name: "Zack",
  last_name: "de Boer",
  email: "zdeboer@academic.rrc.ca",
  phone: "4318877481",
  password: "AlphaArrow77*",
  password_confirmation: "AlphaArrow77*"
)

Address.create!(
  customer: demo_customer,
  address_line1: "276 Alex Taylor Drive",
  address_line2: "",
  city: "Winnipeg",
  state: "Manitoba",
  postal_code: "R2C 4P6",
  country: "Canada"
)

# TMDb API setup
TMDB_API_KEY = ENV.fetch("TMDB_API_KEY", "").to_s.strip
TMDB_BASE = "https://api.themoviedb.org/3"
TMDB_IMG = "https://image.tmdb.org/t/p/w500"

def tmdb(path)
  return nil if TMDB_API_KEY.empty?

  http_get_json(URI("#{TMDB_BASE}#{path}?api_key=#{TMDB_API_KEY}"))
end

puts "Importing movies from TMDb..."

movie_ids = [27205, 155, 157336] # Inception, The Dark Knight, Interstellar

movie_ids.each do |id|
  data = tmdb("/movie/#{id}")

  if data.nil?
    puts "TMDb unavailable (missing key or network issue) — skipping movie #{id}."
    next
  end

  if data["status_code"]
    puts "TMDb error for movie #{id}: #{data["status_message"]}"
    next
  end

  if data["genres"].nil? || data["genres"].empty?
    puts "Movie #{id} has no genres — skipping."
    next
  end

  genre_name = data["genres"].first["name"]
  genre = Genre.find_or_create_by!(name: genre_name)

  product = Product.create!(
    name: data["title"],
    description: data["overview"].presence || "No description available.",
    price: rand(10..30),
    genre: genre,
    media_type: media_types[:bluray],
    image_url: data["poster_path"].present? ? "#{TMDB_IMG}#{data["poster_path"]}" : nil
  )

  ["DVD", "Blu-ray", "VHS"].each do |format|
    puts "Creating variation for #{product.name}"

    variation = ProductVariation.create!(
      product: product,
      variation_name: "Format",
      variation_value: format,
      sku: "MOV-#{id}-#{format[0..2].upcase}"
    )

    puts "Creating inventory for #{product.name}"

    Inventory.create!(
      product_variation: variation,
      quantity: rand(5..20),
      last_updated: Time.now
    )
  end
end

puts "Movies imported."

# -----------------------------
# MUSICBRAINZ PUBLIC API
# -----------------------------
def mb_get_release_group(mbid)
  uri = URI("https://musicbrainz.org/ws/2/release-group/#{mbid}?fmt=json&inc=artist-credits+releases")
  contact = ENV.fetch("MUSICBRAINZ_CONTACT", "").to_s.strip
  contact = "n/a" if contact.empty?

  http_get_json(uri, headers: { "User-Agent" => "ZacksMediaStore/1.0 (#{contact})" })
end

puts "Importing music albums..."

albums = {
  "Dark Side of the Moon" => "f5093c06-23e3-404f-aeaa-40f72885ee3a",
  "Abbey Road" => "9162580e-5df4-32de-80cc-f45a8d8a9b1d"
}

albums.each do |album_name, mbid|
  data = mb_get_release_group(mbid)

  if data.nil?
    puts "MusicBrainz unavailable — skipping #{album_name}."
    next
  end

  if data["title"].nil?
    puts "Skipping #{album_name} — MusicBrainz returned no title."
    next
  end

  cover_url = "https://coverartarchive.org/release-group/#{mbid}/front"
  genre = Genre.find_or_create_by!(name: "Music")

  product = Product.create!(
    name: data["title"],
    description: "Music album: #{data["title"]}",
    price: rand(15..40),
    genre: genre,
    media_type: media_types[:vinyl],
    image_url: cover_url
  )

  ["Vinyl", "CD"].each do |format|
    variation = ProductVariation.create!(
      product: product,
      variation_name: "Format",
      variation_value: format,
      sku: "ALB-#{mbid[0..5]}-#{format[0..2].upcase}"
    )

    Inventory.create!(
      product_variation: variation,
      quantity: rand(3..15),
      last_updated: Time.now
    )
  end
end

puts "Music imported."

if Product.count.zero?
  puts "No external API data imported — creating fallback products..."

  fallback_genre = Genre.find_or_create_by!(name: "Fallback")

  fallback_products = [
    { name: "Sample Movie", description: "A sample movie product.", price: 19.99, media_type: media_types[:dvd] },
    { name: "Sample Album", description: "A sample album product.", price: 24.99, media_type: media_types[:vinyl] }
  ]

  fallback_products.each_with_index do |attrs, idx|
    product = Product.create!(
      name: attrs[:name],
      description: attrs[:description],
      price: attrs[:price],
      genre: fallback_genre,
      media_type: attrs[:media_type],
      image_url: nil
    )

    variation = ProductVariation.create!(
      product: product,
      variation_name: "Format",
      variation_value: attrs[:media_type].name,
      sku: "FALL-#{idx}-#{attrs[:media_type].name[0..2].upcase}"
    )

    Inventory.create!(
      product_variation: variation,
      quantity: 10,
      last_updated: Time.now
    )
  end
end