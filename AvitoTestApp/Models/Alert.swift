import Foundation

struct Alert {
    let title: String
    let message: String
    let leftButton: String
    let rightButton: String
    let completion: (() -> Void)
}
