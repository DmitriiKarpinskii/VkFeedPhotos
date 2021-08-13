//
//  PhotosFeedModels.swift
//  VkPhotosFeed
//
//  Created by Dmitry Karpinsky on 04.08.2021.
//  Copyright (c) 2021 ___ORGANIZATIONNAME___. All rights reserved.
//

import UIKit

enum PhotosFeed {
    
    enum Model {
        struct Request {
            enum RequestType {
                case getPhotosFeed
            }
        }
        struct Response {
            enum ResponseType {
                case presentPhotosFeed(feed: FeedResponse)
            }
        }
        struct ViewModel {
            enum ViewModelData {
                case displayPhotosFeed(feedViewModel: FeedViewModel)
            }
        }
    }
}

struct FeedViewModel {
    let cells: [Cell]
    struct Cell: FeedCellViewModel {
        var imagePhotoURL: String
        var date: String
    }
}
