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
    private var fetcher : DataFetcher? = NetworkDataFethcer(networkig: NetworkService())
    
    
    func makeRequest(request: PhotosFeed.Model.Request.RequestType) {
        print(#function)
        
        switch request {
        case .getPhotosFeed:
            
            guard let fetcher = fetcher else { return }
            
            fetcher.getFeed { [weak self] (feedResponse, error) in
                guard let self = self  , let presenter = self.presenter else { return }
                if let feedResponse = feedResponse {
                    presenter.presentData(response: .presentPhotosFeed(feed: feedResponse))
                } else if let error = error {
                    presenter.presentData(response: .presentError(error: PhotosFeedError.otherError(error: error)))
                } else {
                    presenter.presentData(response: .presentError(error: PhotosFeedError.nullResponseError))
                }
            }
        }
    }
}
