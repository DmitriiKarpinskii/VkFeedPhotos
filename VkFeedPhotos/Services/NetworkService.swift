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
    
    private let authService: AuthService
    
    init(authService : AuthService = SceneDelegate.shared().authService) {
        self.authService = authService
    }
    
    func request(path: String, params: [String : String], completion: @escaping (Data?, Error?) -> Void) {
       
        guard let token = authService.token else { return }
//        let params = ["owner_id" : API.idClub, "album_id" : API.idAlbum]
        var allParams = params
        allParams["access_token"] = token
        allParams["v"] = API.version

        let url = self.url(from: path, params: allParams)
        let request = URLRequest(url: url)
        let task = createDataTask(from: request, completion: completion)
        task.resume()
    }
    
    private func createDataTask(from request: URLRequest, completion: @escaping (Data?, Error?) -> ()) -> URLSessionDataTask {
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

// https://api.vk.com/method/users.get?user_ids=210700286&fields=bdate&access_token=533bacf01e11f55b536a565b57531ac114461ae8736d6506a3&v=5.131

//https://api.vk.com/method/photos.get?access_token=0a6d3861a00674d4e9e94f741c1b9821cd8acea6dac2b348d34962d44e389942144f6e9eb45293fcd6e65&album_id=266276915&owner_id=-128666765&v=5.131
