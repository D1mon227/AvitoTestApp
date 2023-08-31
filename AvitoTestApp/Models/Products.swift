import Foundation

struct Advertisements: Decodable {
    let advertisements: [Products]
}

struct Products: Decodable {
    let id: String
    let title: String
    let price: String
    let location: String
    let image_url: URL
    let created_date: String
}
