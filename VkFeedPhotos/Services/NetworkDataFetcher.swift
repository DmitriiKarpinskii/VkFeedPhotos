//
//  NetworkDataFetcher.swift
//  VkPhotosFeed
//
//  Created by Dmitry Karpinsky on 05.08.2021.
//

import Foundation

protocol DataFetcher {
    func getFeed(completion: @escaping (FeedResponse?, Error?) -> Void)
}

struct NetworkDataFethcer: DataFetcher {
    
    let networkig : Networking?
    
    init?(networkig: Networking?) {
        guard let networkig = networkig else { return nil }
        self.networkig = networkig
    }
    
    func getFeed(completion: @escaping (FeedResponse?, Error?) -> Void) {
        print(#function)
        let params = ["owner_id" : API.idClub, "album_id" : API.idAlbum]
        guard let networkig = networkig else { return }
        networkig.request(path: API.photosFeed, params: params) { (data, error) in
            
            if let error = error {
                print("Error received requsting data: \(error.localizedDescription)")
                completion(nil, error)
            }
            
            let decodedData = self.decodeJSON(type: FeedResponseWrapped.self, from: data)
            completion(decodedData?.response, nil)
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
