import Foundation

protocol DateConvertable {
    func convert(date: String) -> String
}

extension String {
    static let inputDateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter
    }()

    static let outputDateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "d MMMM yyyy"
        formatter.locale = Locale(identifier: "ru_RU")
        return formatter
    }()
    
    func convert() -> String {
        var formattedDate = ""
        if let date = String.inputDateFormatter.date(from: self) {
            formattedDate = String.outputDateFormatter.string(from: date)
        }
        return formattedDate
    }
}

extension DateConvertable {
    func convert(date: String) -> String {
        return date.convert()
    }
}
