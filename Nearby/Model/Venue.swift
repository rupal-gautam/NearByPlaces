import Foundation

struct VenueResponse: Codable {
    let venues: [Venue]
    let meta: Meta
}

struct Venue: Codable, Identifiable {
    let id: Int
    let name: String
    let city: String
    let address: String?
    let location: Location
    let url: String
}

struct Location: Codable {
    let lat: Double
    let lon: Double
}

struct Meta: Codable {
    let total: Int
    let geolocation: Geolocation
}

struct Geolocation: Codable {
    let lat: Double
    let lon: Double
    let city: String
    let state: String
    let country: String
    let postal_code: String
    let display_name: String
    let range: String
}

