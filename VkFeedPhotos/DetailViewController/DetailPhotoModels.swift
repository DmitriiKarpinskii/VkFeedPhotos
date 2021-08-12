//
//  DetailPhotoModels.swift
//  VkPhotosFeed
//
//  Created by Dmitry Karpinsky on 11.08.2021.
//

import Foundation

enum DetailPhoto {
    
    enum Model {
        struct Request {
            enum RequestType {
                case getPhoto
            }
        }
        struct Response {
            enum ResponseType {
                case presentPhoto(feed: DetailPhotoFeedViewModel)
            }                           
        }
        struct ViewModel {
            enum ViewModelData {
                case displayPhotosFeed(cell: FeedViewModel.Cell)
            }
        }
    }
}

struct DetailPhotoFeedViewModel {
    let idCurrentCell: Int
    let cells: [FeedViewModel.Cell]
 
}
