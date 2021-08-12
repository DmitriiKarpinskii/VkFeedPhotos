//
//  DetailPhotosViewController.swift
//  VkPhotosFeed
//
//  Created by Dmitry Karpinsky on 11.08.2021.
//

import UIKit

protocol DetailPhotosDisplayLogic {
    func displayData(viewModel: DetailPhoto.Model.ViewModel.ViewModelData)
}

class DetailPhotoViewController: UIViewController, DetailPhotosDisplayLogic {
   
    @IBOutlet weak var imageView: WebImageView!
    @IBOutlet weak var urlLabel: UILabel!
    var imageName : String?
    
    //MARK: - External
    
    private(set) var router: (DetailPhotoRoutingLogic & DetailPhotoRoutingDataPassing)?
    
    //MARK: - Internal
    
    private var interactor: (DetailPhotosBusinessLogic & DetailPhotoStoreProtocol)?
    
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
        let interactor            = DetailPhotosInteractor()
        let presenter             = DetailPhotoPresenter()
        let router                = DetailPhotosRouter()
        viewController.interactor = interactor
        viewController.router     = router
        interactor.presenter      = presenter
        presenter.viewController  = viewController
        router.viewController     = viewController
        router.dataStore = interactor
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        interactor?.fetchDetails()
        setupNavigationItems()
            
     
    }
    
    private func setupNavigationItems() {
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .save,
                                                            target: self,
                                                            action: nil)
        navigationItem.rightBarButtonItem?.tintColor = .black
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)

        
    }
    
    func displayData(viewModel: DetailPhoto.Model.ViewModel.ViewModelData) {
        switch viewModel {
        case .displayPhotosFeed(cell: let feed):
            title = feed.date
//            urlLabel.text = viewModel.imagePhotoURL
            let webImageView = WebImageView()
            webImageView.set(imageUrl: feed.imagePhotoURL)
            imageView.image = webImageView.image
        }
    }
    
}
