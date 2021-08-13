//
//  DetailPhotoPresenter.swift
//  VkPhotosFeed
//
//  Created by Dmitry Karpinsky on 11.08.2021.
//

import Foundation

protocol DetailPhotoPresentationLogic {
    func presentData(response: DetailPhoto.Model.Response.ResponseType)
}

class DetailPhotoPresenter: NSObject, DetailPhotoPresentationLogic {
  
    weak var viewController: DetailPhotoViewController?

    func presentData(response: DetailPhoto.Model.Response.ResponseType) {
        switch response {
        case .presentPhoto(feed: let feed):
           
//            let idCell = feed.idCurrentCell
//            let cell = feed.cells[idCell]
            viewController?.displayData(viewModel: .displayPhotosFeed(cell: feed))
        }
    }
    
    
}

