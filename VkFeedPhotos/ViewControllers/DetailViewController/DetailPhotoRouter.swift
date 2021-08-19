//
//  DetailPhotoRouter.swift
//  VkPhotosFeed
//
//  Created by Dmitry Karpinsky on 11.08.2021.
//

import Foundation

protocol DetailPhotoRoutingLogic {
    
}

protocol  DetailPhotoRoutingDataPassing {
    var dataStore: DetailPhotoStoreProtocol? { get }
}

class DetailPhotosRouter : NSObject, DetailPhotoRoutingLogic, DetailPhotoRoutingDataPassing {
    
    weak var viewController : DetailPhotoViewController?
    var dataStore: DetailPhotoStoreProtocol?
}
