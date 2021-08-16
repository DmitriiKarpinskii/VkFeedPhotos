//
//  NetworkDataFetcher.swift
//  VkPhotosFeed
//
//  Created by Dmitry Karpinsky on 05.08.2021.
//

import Foundation

protocol DataFetcher {
    func getFeed(response: @escaping (FeedResponse?) -> Void)
}

struct NetworkDataFethcer: DataFetcher {
    
    let networkig : Networking
    
    init(networkig: Networking) {
        self.networkig = networkig
    }
    
    func getFeed(response: @escaping (FeedResponse?) -> Void) {

        let params = ["owner_id" : API.idClub, "album_id" : API.idAlbum]
        networkig.request(path: API.photosFeed, params: params) { (data, error) in
            if let error = error {
                print("Error received requsting data: \(error.localizedDescription)")
                response(nil)
            }
            
            let decoded = self.decodeJSON(type: FeedResponseWrapped.self, from: data)
            response(decoded?.response)
        }
    }
    
    private func decodeJSON<T:Decodable>(type: T.Type, from data: Data?) -> T? {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        guard let data = data else { return nil}
        let result = try? decoder.decode(type.self, from: data)
        return result
    }
}
