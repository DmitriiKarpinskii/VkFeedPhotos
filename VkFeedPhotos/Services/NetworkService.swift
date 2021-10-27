//
//  NetworkService.swift
//  VkPhotosFeed
//
//  Created by Dmitry Karpinsky on 05.08.2021.
//

import Foundation


protocol Networking {
    func request(path: String, params: [String: String], completion: @escaping (Data?, Error?) -> Void)
}

final class NetworkService : Networking {
    
    private let authService: AuthService?
    
    init?() {
        guard let sceneDelegate = SceneDelegate.shared() else { return nil}
        self.authService = sceneDelegate.authService
    }
    
    func request(path: String, params: [String : String], completion: @escaping (Data?, Error?) -> Void) {
        
        guard let authService = self.authService, let token = authService.token else { return }
        var allParams = params
        allParams["access_token"] = token
        allParams["v"] = API.version
        
        let url = self.url(from: path, params: allParams)
        let request = URLRequest(url: url)
        let task = createDataTask(from: request, completion: completion)
        task.resume()
    }
    
    private func createDataTask(from request: URLRequest, completion: @escaping (Data?, Error?) -> ()) -> URLSessionDataTask {
        print(request.url)
        return URLSession.shared.dataTask(with: request) { (data, response, error) in
            DispatchQueue.main.async {
                completion(data,error)
            }
        }
    }
    
    private func url(from path: String, params: [String : String ]) -> URL {
        var components = URLComponents()
        components.scheme = API.scheme
        components.host = API.host
        components.path = API.photosFeed
        components.queryItems = params.map { URLQueryItem(name: $0, value: $1) }
        return components.url!
    }
}
