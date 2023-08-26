import UIKit

private let inputDateFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateFormat = "yyyy-MM-d"
    return formatter
}()

private let outputDateFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateFormat = "d MMMM yyyy"
    formatter.locale = Locale(identifier: "ru_RU")
    return formatter
}()

extension UICollectionViewCell {
    static var identifier: String {
        String(describing: self)
    }
    
    func convert(date: String) -> String {
        var formattedDate = ""
        if let date = inputDateFormatter.date(from: date) {
            formattedDate = outputDateFormatter.string(from: date)
        }
        return formattedDate
    }
}
