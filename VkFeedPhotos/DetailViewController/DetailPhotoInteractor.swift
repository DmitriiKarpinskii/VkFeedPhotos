//
//  DetailPhotosInteractor.swift
//  VkPhotosFeed
//
//  Created by Dmitry Karpinsky on 11.08.2021.
//

import Foundation

protocol DetailPhotosBusinessLogic {
    func fetchDetails()
}

protocol DetailPhotoStoreProtocol : class {
    var feedPhotos: DetailPhotoFeedViewModel! { get set }
}

class DetailPhotosInteractor : NSObject, DetailPhotosBusinessLogic, DetailPhotoStoreProtocol {
    var presenter: DetailPhotoPresentationLogic?
    var feedPhotos: DetailPhotoFeedViewModel!
    
    func fetchDetails() {
        presenter?.presentData(response: .presentPhoto(feed: feedPhotos))
        print("interactor")
    }
    
}
