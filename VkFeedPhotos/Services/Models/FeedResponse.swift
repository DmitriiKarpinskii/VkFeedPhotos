//
//  FeedResponse.swift
//  VkPhotosFeed
//
//  Created by Dmitry Karpinsky on 05.08.2021.
//

import Foundation


struct FeedResponseWrapped : Decodable {
    let response : FeedResponse
}

struct FeedResponse : Decodable  {
    let count: Int
    var items: [FeedItem]
}

struct FeedItem : Decodable {
    let id: Int
    let photo604: String
    let date: Double
}
