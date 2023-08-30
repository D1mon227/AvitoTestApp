import UIKit

enum Resources {
    enum Network {
        static let baseURL = "https://www.avito.st/s/interns-ios"
        
        enum Paths {
            static let mainPage = "/main-page.json"
            static let detailsPage = "/details/"
        }
    }
    
    enum Images {
        static let backButton = UIImage(systemName: "chevron.backward")
    }
}

enum Sort {
    case bydate
    case fromCheap
    case fromExpensive
    case fromAtoZ
    case fromZtoA
}
