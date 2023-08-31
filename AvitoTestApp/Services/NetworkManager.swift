import Foundation

enum NetworkClientError: Error {
    case httpStatusCode(Int)
    case urlRequestError(Error)
    case parsingError
}

protocol NetworkClient {
    func fetchData<T:Decodable>(
        for url: URL,
        type: T.Type,
        completion: @escaping (Result<T, Error>) -> Void)
}

final class NetworkManager: NetworkClient {
    private let urlSession: URLSession
    private let decoder: JSONDecoder
    
    init(urlSession: URLSession = URLSession.shared,
         decoder: JSONDecoder = JSONDecoder()) {
        self.urlSession = urlSession
        self.decoder = decoder
    }
    
    func fetchData<T:Decodable>(for url: URL,
                                type: T.Type,
                                completion: @escaping (Result<T, Error>) -> Void) {
        
            let fulFillCompletion: (Result<T, Error>) -> Void = { result in
                DispatchQueue.main.async {
                    completion(result)
                }
            }
            
            let request = URLRequest(url: url)
            let task = urlSession.dataTask(with: request) { data, responce, error in
                if let data = data,
                   let responce = responce,
                   let statusCode = (responce as? HTTPURLResponse)?.statusCode {
                    if 200..<300 ~= statusCode {
                        self.parse(data: data, type: type, completion: fulFillCompletion)
                    } else {
                        fulFillCompletion(.failure(NetworkClientError.httpStatusCode(statusCode)))
                    }
                } else if let error = error {
                    fulFillCompletion(.failure(NetworkClientError.urlRequestError(error)))
                }
            }
            task.resume()
    }
    
    private func parse<T: Decodable>(data: Data,
                                     type: T.Type,
                                     completion: @escaping (Result<T, Error>) -> Void) {
        do {
            let responce = try decoder.decode(T.self, from: data)
            completion(.success(responce))
        } catch {
            completion(.failure(NetworkClientError.parsingError))
        }
    }
}
