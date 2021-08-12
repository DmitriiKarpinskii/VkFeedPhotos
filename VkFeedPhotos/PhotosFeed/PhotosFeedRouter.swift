//
//  PhotosFeedRouter.swift
//  VkPhotosFeed
//
//  Created by Dmitry Karpinsky on 04.08.2021.
//  Copyright (c) 2021 ___ORGANIZATIONNAME___. All rights reserved.
//

import UIKit

protocol PhotosFeedRoutingLogic {
    func navigateToDetails(feedViewModel: DetailPhotoFeedViewModel)
}

class PhotosFeedRouter: NSObject, PhotosFeedRoutingLogic {

  weak var viewController: PhotosFeedViewController?
  
  // MARK: Routing

      func navigateToDetails(feedViewModel: DetailPhotoFeedViewModel) {
        
        let detailVC = DetailPhotoViewController(nibName: "DetailPhotoViewController", bundle: nil)
        detailVC.router?.dataStore?.feedPhotos = feedViewModel
        viewController?.navigationController?.pushViewController(detailVC, animated: true)
      }
}
