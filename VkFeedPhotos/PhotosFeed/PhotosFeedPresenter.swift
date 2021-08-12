//
//  PhotosFeedPresenter.swift
//  VkPhotosFeed
//
//  Created by Dmitry Karpinsky on 04.08.2021.
//  Copyright (c) 2021 ___ORGANIZATIONNAME___. All rights reserved.
//

import UIKit

protocol PhotosFeedPresentationLogic {
    func presentData(response: PhotosFeed.Model.Response.ResponseType)
}

class PhotosFeedPresenter: PhotosFeedPresentationLogic {
    weak var viewController: PhotosFeedDisplayLogic?
    let dateFormatrer : DateFormatter = {
        let dt = DateFormatter()
        dt.locale = Locale(identifier: "ru_RU")
        dt.dateFormat = "d MMMM YYYY"
        return dt
    }()
    
    
    func presentData(response: PhotosFeed.Model.Response.ResponseType) {
        
        switch response {
        case .presentPhotosFeed(feed: let feed):
            let cells = feed.items.map { (feedItem) in
                cellViewModel(from: feedItem)
            }
            let feedViewModel = FeedViewModel.init(cells: cells)
            viewController?.displayData(viewModel: .displayPhotosFeed(feedViewModel: feedViewModel))
        }
    }
    
    private func cellViewModel(from feedItem: FeedItem) -> FeedViewModel.Cell {
        let urlImageString = feedItem.photo604
        let date = Date(timeIntervalSince1970: feedItem.date)
        let dateTitle = dateFormatrer.string(from: date)
        
        return FeedViewModel.Cell.init(imagePhotoURL: urlImageString ?? "", date: dateTitle)
    }
}
