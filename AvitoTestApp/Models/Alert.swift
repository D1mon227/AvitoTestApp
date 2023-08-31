import Foundation

enum PresentationStyle {
    case alert
    case actionSheet
}

struct Alert {
    let title: String?
    let message: String?
    let leftButton: String
    let rightButton: String
    let style: PresentationStyle
    let completion: (() -> Void)
}
