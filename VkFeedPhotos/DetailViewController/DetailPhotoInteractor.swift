//
//  DetailPhotosInteractor.swift
//  VkPhotosFeed
//
//  Created by Dmitry Karpinsky on 11.08.2021.
//

import Foundation
import UIKit

protocol DetailPhotosBusinessLogic {
    func fetchDetails(requsest: DetailPhoto.Model.Request.RequestType)
}

protocol DetailPhotoStoreProtocol : class {
    var feedPhotos: DetailPhotoFeedViewModel! { get set }
}

class DetailPhotosInteractor : NSObject, DetailPhotosBusinessLogic, DetailPhotoStoreProtocol {
  
    
    var presenter: DetailPhotoPresentationLogic?
    var feedPhotos: DetailPhotoFeedViewModel!
    
    func fetchDetails(requsest: DetailPhoto.Model.Request.RequestType) {
        switch requsest {
        
        case .getPhotos:
            presenter?.presentData(response: .presentPhoto(feed: feedPhotos))
        case .getPhoto(idPhoto: let idPhoto):
            let newDetailFeedViewModel = DetailPhotoFeedViewModel(idCurrentCell: idPhoto, cells: feedPhotos.cells)
            presenter?.presentData(response: .presentPhoto(feed: newDetailFeedViewModel))
     
        }
     
        
    }
    
}
