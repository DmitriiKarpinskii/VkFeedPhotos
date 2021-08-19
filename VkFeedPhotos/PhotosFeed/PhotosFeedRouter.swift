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

    func navigateToDetails(feedViewModel: DetailPhotoFeedViewModel) {
        
        let detailVC = DetailPhotoViewController(nibName: "DetailPhotoViewController", bundle: nil)
        guard let router = detailVC.router, let dataStorce = router.dataStore else { return }
        dataStorce.feedPhotos = feedViewModel
        guard let vc = viewController, let navigationController = vc.navigationController else { return }
        navigationController.pushViewController(detailVC, animated: true)
      }
}
