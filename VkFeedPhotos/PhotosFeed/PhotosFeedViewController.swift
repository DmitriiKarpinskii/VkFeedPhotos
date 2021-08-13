//
//  PhotosFeedViewController.swift
//  VkPhotosFeed
//
//  Created by Dmitry Karpinsky on 04.08.2021.
//  Copyright (c) 2021 ___ORGANIZATIONNAME___. All rights reserved.
//

import UIKit

protocol PhotosFeedDisplayLogic: class {
    func displayData(viewModel: PhotosFeed.Model.ViewModel.ViewModelData)
}


class PhotosFeedViewController: UIViewController, PhotosFeedDisplayLogic {
    
    @IBOutlet weak var photosCollectionView: UICollectionView!
    
    var interactor: PhotosFeedBusinessLogic?
    var router: (NSObjectProtocol & PhotosFeedRoutingLogic)?
    private var feedViewModel = FeedViewModel.init(cells: [])
    
    
    // MARK: Object lifecycle
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    // MARK: Setup
    
    private func setup() {
        let viewController        = self
        let interactor            = PhotosFeedInteractor()
        let presenter             = PhotosFeedPresenter()
        let router                = PhotosFeedRouter()
        viewController.interactor = interactor
        viewController.router     = router
        interactor.presenter      = presenter
        presenter.viewController  = viewController
        router.viewController     = viewController
    }
    
    deinit {
        print("deinit ViewController")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        setNeedsStatusBarAppearanceUpdate()
    }
    override var preferredStatusBarStyle: UIStatusBarStyle {
        .darkContent
    }
    
    
    
    // MARK: View lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationItems()
        
        photosCollectionView.delegate = self
        photosCollectionView.dataSource = self
        
        let nibCell = UINib(nibName: "PhotoCell", bundle: nil)
        photosCollectionView.register(nibCell, forCellWithReuseIdentifier: PhotoCell.reuseId)
        interactor?.makeRequest(request: .getPhotosFeed)
        
        
    }
    
    func displayData(viewModel: PhotosFeed.Model.ViewModel.ViewModelData) {
        switch viewModel {
        case .displayPhotosFeed(feedViewModel: let feedViewModel):
            self.feedViewModel = feedViewModel
            photosCollectionView.reloadData()
        }
    }

    func setupNavigationItems() {
        title = "Mobile Up Gallary"
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Выход",
                                                            style: .done,
                                                            target:
                                                                self, action: #selector(exitButtonPressed))
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "")
    }
    
    @objc func exitButtonPressed() {
        SceneDelegate.shared().authServiceLogOut()
    }
}

extension PhotosFeedViewController :  UICollectionViewDelegate , UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return feedViewModel.cells.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = photosCollectionView.dequeueReusableCell(withReuseIdentifier: "photoCell", for: indexPath) as! PhotoCell
        cell.set(viewModel: feedViewModel.cells[indexPath.row])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cells = feedViewModel.cells
        let feedPhotosWithIdCurrentCell = DetailPhotoFeedViewModel(idCurrentCell: indexPath.row, cells: cells)
        router?.navigateToDetails(feedViewModel: feedPhotosWithIdCurrentCell)
       
    }
}

extension PhotosFeedViewController : UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let itemsPerRow: CGFloat = 2
        let paddingWidth = 1 * (itemsPerRow + 1)
        let availableWidth = collectionView.frame.width - paddingWidth
        let widthPerItem = availableWidth / itemsPerRow
        
        return CGSize(width: widthPerItem, height: widthPerItem)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0,
                            left: 0,
                            bottom: 0,
                            right: 0)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 2
    }
    
    
}
