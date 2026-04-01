require "net/http"
require "json"

# ============================================================
# HTTP Helper
# ============================================================
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

# ============================================================
# TMDb Helpers
# ============================================================
def invalid_movie_data?(data, id)
  if data.nil? || data["status_code"]
    Rails.logger.debug { "TMDb error or unavailable for movie #{id}." }
    return true
  end

  if data["genres"].blank?
    Rails.logger.debug { "Movie #{id} has no genres — skipping." }
    return true
  end

  false
end

def create_product_from_tmdb(data, media_types)
  genre = Genre.find_or_create_by!(name: data["genres"].first["name"])

  Product.create!(
    name:        data["title"],
    description: data["overview"].presence || "No description available.",
    price:       rand(10..30),
    genre:       genre,
    media_type:  media_types[:bluray],
    image_url:   data["poster_path"].present? ? "#{TMDB_IMG}#{data['poster_path']}" : nil
  )
end

def create_product_variations(product, id)
  ["DVD", "Blu-ray", "VHS"].each do |format|
    variation = ProductVariation.create!(
      product:         product,
      variation_name:  "Format",
      variation_value: format,
      sku:             "MOV-#{id}-#{format[0..2].upcase}"
    )

    Inventory.create!(
      product_variation: variation,
      quantity:          rand(5..20),
      last_updated:      Time.zone.now
    )
  end
end

# ============================================================
# MusicBrainz Helpers
# ============================================================
def invalid_album_data?(data, album_name)
  if data.nil? || data["title"].nil?
    Rails.logger.debug { "Skipping #{album_name} — MusicBrainz issue." }
    return true
  end
  false
end

def create_album_product(data, mbid, media_types)
  genre = Genre.find_or_create_by!(name: "Music")

  Product.create!(
    name:        data["title"],
    description: "Music album: #{data['title']}",
    price:       rand(15..40),
    genre:       genre,
    media_type:  media_types[:vinyl],
    image_url:   "https://coverartarchive.org/release-group/#{mbid}/front"
  )
end

def create_album_variations(product, mbid)
  ["Vinyl", "CD"].each do |format|
    variation = ProductVariation.create!(
      product:         product,
      variation_name:  "Format",
      variation_value: format,
      sku:             "ALB-#{mbid[0..5]}-#{format[0..2].upcase}"
    )

    Inventory.create!(
      product_variation: variation,
      quantity:          rand(3..15),
      last_updated:      Time.zone.now
    )
  end
end

# ============================================================
# BEGIN SEEDING
# ============================================================

Rails.logger.debug "Clearing old data..."

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
Page.destroy_all

# ============================================================
# Static Pages
# ============================================================
Rails.logger.debug "Creating About + Contact pages..."

Page.create!(slug: "about", title: "About Us", content: "Write your about page content here.")
Page.create!(slug: "contact", title: "Contact Us", content: "Write your contact page content here.")

# ============================================================
# Media Types
# ============================================================
Rails.logger.debug "Creating media types..."

media_types = {
  dvd:    MediaType.create!(name: "DVD"),
  bluray: MediaType.create!(name: "Blu-ray"),
  vhs:    MediaType.create!(name: "VHS"),
  vinyl:  MediaType.create!(name: "Vinyl"),
  cd:     MediaType.create!(name: "CD")
}

# ============================================================
# Admin + Demo Customer
# ============================================================
Rails.logger.debug "Creating admin + demo customer..."

AdminUser.create!(
  email:                 "admin@user.com",
  password:              "AlphaArrow77*",
  password_confirmation: "AlphaArrow77*"
)

demo_customer = Customer.create!(
  first_name:            "Zack",
  last_name:             "de Boer",
  email:                 "zdeboer@academic.rrc.ca",
  phone:                 "4318877481",
  password:              "AlphaArrow77*",
  password_confirmation: "AlphaArrow77*"
)

Address.create!(
  customer:      demo_customer,
  address_line1: "276 Alex Taylor Drive",
  city:          "Winnipeg",
  state:         "Manitoba",
  postal_code:   "R2C 4P6",
  country:       "Canada"
)

# ============================================================
# Provinces
# ============================================================
Rails.logger.debug "Seeding provinces..."

Province.upsert_all(
  [
    { name: "Alberta", code: "AB", gst: 0.05, pst: 0.0, hst: 0.0 },
    { name: "British Columbia", code: "BC", gst: 0.05, pst: 0.07, hst: 0.0 },
    { name: "Manitoba", code: "MB", gst: 0.05, pst: 0.07, hst: 0.0 },
    { name: "New Brunswick", code: "NB", gst: 0.0, pst: 0.0, hst: 0.15 },
    { name: "Newfoundland and Labrador", code: "NL", gst: 0.0, pst: 0.0, hst: 0.15 },
    { name: "Nova Scotia", code: "NS", gst: 0.0, pst: 0.0, hst: 0.15 },
    { name: "Northwest Territories", code: "NT", gst: 0.05, pst: 0.0, hst: 0.0 },
    { name: "Nunavut", code: "NU", gst: 0.05, pst: 0.0, hst: 0.0 },
    { name: "Ontario", code: "ON", gst: 0.0, pst: 0.0, hst: 0.13 },
    { name: "Prince Edward Island", code: "PE", gst: 0.0, pst: 0.0, hst: 0.15 },
    { name: "Quebec", code: "QC", gst: 0.05, pst: 0.09975, hst: 0.0 },
    { name: "Saskatchewan", code: "SK", gst: 0.05, pst: 0.06, hst: 0.0 },
    { name: "Yukon", code: "YT", gst: 0.05, pst: 0.0, hst: 0.0 }
  ],
  unique_by: :index_provinces_on_code
)

# ============================================================
# TMDb Import
# ============================================================
TMDB_API_KEY = ENV.fetch("TMDB_API_KEY", "").to_s.strip
TMDB_BASE = "https://api.themoviedb.org/3".freeze
TMDB_IMG = "https://image.tmdb.org/t/p/w500".freeze

def tmdb(path)
  return nil if TMDB_API_KEY.empty?

  http_get_json(URI("#{TMDB_BASE}#{path}?api_key=#{TMDB_API_KEY}"))
end

Rails.logger.debug "Importing movies from TMDb..."

movie_ids = [
  27_205, 155, 157_336, 11, 238, 240, 1891, 1892,
  680, 550, 603, 278, 120, 121, 122, 329, 105,
  8587, 19_995, 597
]

movie_ids.each do |id|
  data = tmdb("/movie/#{id}")
  next if invalid_movie_data?(data, id)

  product = create_product_from_tmdb(data, media_types)
  create_product_variations(product, id)
end

# ============================================================
# MusicBrainz Import
# ============================================================
def mb_get_release_group(mbid)
  uri = URI("https://musicbrainz.org/ws/2/release-group/#{mbid}?fmt=json&inc=artist-credits+releases")
  contact = ENV.fetch("MUSICBRAINZ_CONTACT", "").presence || "n/a"
  http_get_json(uri, headers: { "User-Agent" => "ZacksMediaStore/1.0 (#{contact})" })
end

Rails.logger.debug "Importing music albums..."

albums = {
  "Dark Side of the Moon" => "f5093c06-23e3-404f-aeaa-40f72885ee3a",
  "Abbey Road"            => "9162580e-5df4-32de-80cc-f45a8d8a9b1d",
  "Thriller"              => "3a7817b5-22cb-32c3-a31b-2c8309fbf92e",
  "Close To The Edge"     => "5a59b948-1961-32ff-80d9-e970c7d4ebe9"
}

albums.each do |album_name, mbid|
  data = mb_get_release_group(mbid)
  next if invalid_album_data?(data, album_name)

  product = create_album_product(data, mbid, media_types)
  create_album_variations(product, mbid)
end

# ============================================================
# Fallback Products
# ============================================================
if Product.none?
  Rails.logger.debug "No external API data imported — creating fallback products..."

  fallback_genre = Genre.find_or_create_by!(name: "Fallback")

  fallback_products = [
    { name: "Sample Movie", description: "A sample movie product.", price: 19.99,
media_type: media_types[:dvd] },
    { name: "Sample Album", description: "A sample album product.", price: 24.99,
media_type: media_types[:vinyl] }
  ]

  fallback_products.each_with_index do |attrs, idx|
    product = Product.create!(
      name:        attrs[:name],
      description: attrs[:description],
      price:       attrs[:price],
      genre:       fallback_genre,
      media_type:  attrs[:media_type],
      image_url:   nil
    )

    variation = ProductVariation.create!(
      product:         product,
      variation_name:  "Format",
      variation_value: attrs[:media_type].name,
      sku:             "FALL-#{idx}-#{attrs[:media_type].name[0..2].upcase}"
    )

    Inventory.create!(
      product_variation: variation,
      quantity:          10,
      last_updated:      Time.zone.now
    )
  end
end

Rails.logger.debug "Seeding complete."
