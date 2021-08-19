//
//  FeedResopnseError.swift
//  VkPhotosFeed
//
//  Created by Dmitry Karpinsky on 19.08.2021.
//

import Foundation

struct FeedResopnseError : Decodable {
    let error: ErrorInfo
}

struct ErrorInfo: Decodable {
    let error_code: Int
    let error_ms: String
}
