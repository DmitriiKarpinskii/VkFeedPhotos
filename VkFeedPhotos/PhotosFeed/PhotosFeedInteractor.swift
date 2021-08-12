//
//  PhotosFeedInteractor.swift
//  VkPhotosFeed
//
//  Created by Dmitry Karpinsky on 04.08.2021.
//  Copyright (c) 2021 ___ORGANIZATIONNAME___. All rights reserved.
//

import UIKit

protocol PhotosFeedBusinessLogic {
  func makeRequest(request: PhotosFeed.Model.Request.RequestType)
}

class PhotosFeedInteractor: PhotosFeedBusinessLogic {

  var presenter: PhotosFeedPresentationLogic?
  var service: PhotosFeedService?
  private var fetcher : DataFetcher = NetworkDataFethcer(networkig: NetworkService())
    
  
  func makeRequest(request: PhotosFeed.Model.Request.RequestType) {
    if service == nil {
      service = PhotosFeedService()
    }
    
    switch request {
    case .getPhotosFeed:
        fetcher.getFeed { [weak self] (feedResponse) in
            guard let feedResponse = feedResponse else { return }
            self?.presenter?.presentData(response: .presentPhotosFeed(feed: feedResponse))
        }
    }
  }
}
