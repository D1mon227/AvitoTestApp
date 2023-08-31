import Foundation

enum NetworkError: Error {
    case httpStatusCode(Int)
    case urlRequestError(Error)
    case urlSessionError
}

final class NetworkManager {
    private let urlSession = URLSession.shared
    private var task: URLSessionTask?
    
    func fetchProducts(completion: @escaping (Result<[Products], Error>) -> Void) {
        
        assert(Thread.isMainThread)
        if task != nil { return }
        
        let urlString = Resources.Network.baseURL + Resources.Network.Paths.mainPage
        guard let url = URL(string: urlString) else { return }
        let task = urlSession.dataTask(with: url) { data, responce, error in
            if let data = data,
               let responce = responce,
               let statusCode = (responce as? HTTPURLResponse)?.statusCode {
                if 200..<300 ~= statusCode {
                    let decoder = JSONDecoder()
                    if let json = try? decoder.decode(Advertisements.self, from: data) {
                        DispatchQueue.main.async {
                            completion(.success(json.advertisements))
                        }
                    }
                } else {
                    DispatchQueue.main.async {
                        completion(.failure(NetworkError.httpStatusCode(statusCode)))
                    }
                }
            } else {
                DispatchQueue.main.async {
                    guard let error = error else { return }
                    completion(.failure(NetworkError.urlRequestError(error)))
                }
            }
        }
        self.task = task
        task.resume()
    }
    
    func fetchProductInfo(id: String, completion: @escaping (Result<ProductInfo, Error>) -> Void) {
        
        assert(Thread.isMainThread)
        if task != nil { return }
        
        let urlString = Resources.Network.baseURL + Resources.Network.Paths.detailsPage + "\(id).json"
        guard let url = URL(string: urlString) else { return }
        let task = urlSession.dataTask(with: url) { data, responce, error in
            if let data = data,
               let responce = responce,
               let statusCode = (responce as? HTTPURLResponse)?.statusCode {
                if 200..<300 ~= statusCode {
                    let decoder = JSONDecoder()
                    if let json = try? decoder.decode(ProductInfo.self, from: data) {
                        DispatchQueue.main.async {
                            completion(.success(json))
                        }
                    }
                } else {
                    DispatchQueue.main.async {
                        completion(.failure(NetworkError.httpStatusCode(statusCode)))
                    }
                }
            } else {
                DispatchQueue.main.async {
                    guard let error = error else { return }
                    completion(.failure(NetworkError.urlRequestError(error)))
                }
            }
        }
        self.task = task
        task.resume()
    }
}
