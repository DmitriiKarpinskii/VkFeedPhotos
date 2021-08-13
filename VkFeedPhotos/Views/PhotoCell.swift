//
//  CollectionViewCell.swift
//  VkPhotosFeed
//
//  Created by Dmitry Karpinsky on 05.08.2021.
//

import UIKit


protocol FeedCellViewModel {
    var imagePhotoURL: String { get }
    var date: String { get }
}

class PhotoCell: UICollectionViewCell {

    static let reuseId = "photoCell"
    
    @IBOutlet weak var imagePhotoView: WebImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func set(viewModel: FeedCellViewModel) {
        imagePhotoView.set(imageUrl: viewModel.imagePhotoURL)
    }
    
    override func prepareForReuse() {
        imagePhotoView.set(imageUrl: nil)
    }
}
