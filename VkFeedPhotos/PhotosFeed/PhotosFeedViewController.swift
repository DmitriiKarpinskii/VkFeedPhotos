//
//  PhotosFeedViewController.swift
//  VkPhotosFeed
//
//  Created by Dmitry Karpinsky on 04.08.2021.
//  Copyright (c) 2021 ___ORGANIZATIONNAME___. All rights reserved.
//

import UIKit

protocol PhotosFeedDisplayLogic : AnyObject {
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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        setNeedsStatusBarAppearanceUpdate()
    }
    override var preferredStatusBarStyle: UIStatusBarStyle {
        .darkContent
    }
    
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
        case .displayErrorAlert(error: let error):
            self.showAlert(with: "Ошибка", message: "\(error.localizedDescription)")
            print(error.localizedDescription)
        }
    }
    
    func setupNavigationItems() {
        title = "Mobile Up Gallary"
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "")
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Выход",
                                                            style: .done,
                                                            target: self,
                                                            action: #selector(exitButtonPressed))
        
        if let barFont = UIFont(name: "AppleSDGothicNeo-Bold", size: 18) {
            navigationItem.rightBarButtonItem?.setTitleTextAttributes(
                [NSAttributedString.Key.foregroundColor: UIColor.black, NSAttributedString.Key.font: barFont],
                for: .normal)
        }
    }
    
    @objc func exitButtonPressed() {
        guard let sceneDelegate = SceneDelegate.shared() else { return }
        sceneDelegate.authServiceLogOut()
    }
}

extension PhotosFeedViewController :  UICollectionViewDelegate , UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return feedViewModel.cells.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = photosCollectionView.dequeueReusableCell(withReuseIdentifier: "photoCell", for: indexPath)
                as? PhotoCell else { return UICollectionViewCell() }
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
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let itemsPerRow: CGFloat = 2
        let paddingWidth = itemsPerRow
        let availableWidth = collectionView.frame.width - paddingWidth
        let widthPerItem = availableWidth / itemsPerRow
        
        return CGSize(width: widthPerItem, height: widthPerItem)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout,
                        insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout,
                        minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 2
    }
}
