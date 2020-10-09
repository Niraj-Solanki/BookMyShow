//
//  NetworkManager.swift
//  BookMyShow
//
//  Created by Neeraj Solanki on 10/10/20.
//  Copyright © 2020 Mr.Solanki. All rights reserved.
//

import Foundation

protocol URLSessionDataTaskProtocol {
    func resume()
    func cancel()
}

protocol URLSessionProtocol {
    func dataTask(with request: URLRequest, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTaskProtocol
}

class HTTPClient {
    // MARK: Typealias
    typealias CompletionResult = (Result<Data?, BMSError>) -> Void
    
    // MARK: - Shared Instance
    static let shared = HTTPClient(session: URLSession.shared)
    
    // MARK: - Private Properties
    private let session: URLSessionProtocol
    private var task: URLSessionDataTaskProtocol?
    private var completionResult: CompletionResult?
    
    // MARK: - Initialiser
    init(session: URLSessionProtocol) {
        self.session = session
    }
    
    // MARK: - Data Task Helper
    func dataTask(_ request: RequestProtocol, completion: @escaping CompletionResult) {
        completionResult = completion
        var urlRequest = URLRequest(url: request.baseURL.appendingPathComponent(request.path),
                                    cachePolicy: .reloadIgnoringLocalAndRemoteCacheData,
                                    timeoutInterval: Constants.Service.timeout)
        urlRequest.httpMethod = request.httpMethod.rawValue
        urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        do{
         try request.encoding.encode(urlRequest: &urlRequest, with: request.parameters ?? BMSParameters())
        }
        catch{
            print("Encode Failed")
        }
        
        task = session.dataTask(with: urlRequest) { (data, response, error) in
            //return error if there is any error in making request
            if let error = error {
                self.completionResult(.failure(BMSError(error.localizedDescription)))
                return
            }
            
            //check response
            if let response = response, response.isSuccess {
                if let data = data {
                    self.completionResult(.success(data))
                }
                
                if response.httpStatusCode == 204 {
                    self.completionResult(.success(nil))
                }
            } else {
                let commonErrorMessage = NSLocalizedString("Somthing went wrong!", comment: "")
                guard let data = data else {
                    self.completionResult(.failure(BMSError(commonErrorMessage)))
                    return
                }
                do {
                    let serverError = try JSONDecoder().decode(ServerError.self, from: data)
                    self.completionResult(.failure(BMSError(serverError.error ?? commonErrorMessage)))
                } catch {
                    self.completionResult(.failure(BMSError(commonErrorMessage)))
                }
            }
        }
        
        //Resume task
        self.task?.resume()
    }
    
    func cancel() {
        self.task?.cancel()
    }
    
    // MARK: - Private Helper Function
    private func completionResult(_ result: Result<Data?, BMSError>) {
        DispatchQueue.main.async {
            self.completionResult?(result)
        }
    }
}
