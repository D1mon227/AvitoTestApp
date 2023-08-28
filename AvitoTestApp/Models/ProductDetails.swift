import Foundation

struct ProductInfo: Decodable {
    let id: String
    let title: String
    let price: String
    let location: String
    let image_url: URL
    let created_date: String
    let description: String
    let email: String
    let phone_number: String
    let address: String
}
