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
    
    @IBOutlet weak var photosDetailCollectionView: UICollectionView!
    @IBOutlet weak var imageView: WebImageView!
    let pinchgesture = UIPinchGestureRecognizer()
    var feedPhotos = [FeedCellViewModel]()
    
    private(set) var router: (DetailPhotoRoutingLogic & DetailPhotoRoutingDataPassing)?
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
        interactor?.fetchDetails(requsest: .getPhotos)
        setupNavigationItems()
        photosDetailCollectionView.delegate = self
        photosDetailCollectionView.dataSource = self
        imageView.isUserInteractionEnabled = true
        imageView.addGestureRecognizer(pinchgesture)
        pinchgesture.addTarget(self, action: #selector(pinchedImage))
        
        let nibCell = UINib(nibName: "PhotoCell", bundle: nil)
        photosDetailCollectionView.register(nibCell, forCellWithReuseIdentifier: PhotoCell.reuseId)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        setNeedsStatusBarAppearanceUpdate()
    }
    override var preferredStatusBarStyle: UIStatusBarStyle {
        .darkContent
    }
    
    private func setupNavigationItems() {
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "square.and.arrow.up"),
                                                            style: .plain,
                                                            target: self,
                                                            action: #selector(saveToPhotos))
    }
    
    @objc func pinchedImage() {
        guard  let gestureView = pinchgesture.view else { return }
        gestureView.transform = gestureView.transform.scaledBy(x: pinchgesture.scale, y:  pinchgesture.scale)
        pinchgesture.scale = 1
    }
    
    @objc func saveToPhotos() {
        print(#function)
        let shareController = UIActivityViewController(activityItems: [imageView.image!], applicationActivities: nil)
        present(shareController, animated: true, completion: nil)
        shareController.completionWithItemsHandler = { _, bool, _ ,_ in
            let alert = UIAlertController(title: "", message: nil, preferredStyle: .alert)
            let okButton = UIAlertAction(title: "ок", style: .default, handler: nil)
            alert.addAction(okButton)
            alert.title = bool ? "Фотография успешно сохранена" : "Не удалось сохранить фотографию"
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    func displayData(viewModel: DetailPhoto.Model.ViewModel.ViewModelData) {
        switch viewModel {
        case .displayPhotosFeed(cell: let feed):
            
            let idCell = feed.idCurrentCell
            let cells = feed.cells
            let currentCell = cells[idCell]
            title = currentCell.date
            let webImageView = WebImageView()
            webImageView.set(imageUrl: currentCell.imagePhotoURL)
            imageView.image = webImageView.image
            feedPhotos = cells
            photosDetailCollectionView.reloadData()
        }
    }
}

extension DetailPhotoViewController : UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return feedPhotos.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = photosDetailCollectionView.dequeueReusableCell(withReuseIdentifier: PhotoCell.reuseId, for: indexPath) as! PhotoCell
        cell.set(viewModel: feedPhotos[indexPath.row])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        photosDetailCollectionView.selectItem(at: indexPath, animated: true, scrollPosition: .centeredHorizontally)
        interactor?.fetchDetails(requsest: .getPhoto(idPhoto: indexPath.row))
    }
}

extension DetailPhotoViewController : UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let widthCell = collectionView.frame.height
        return CGSize(width: widthCell, height: widthCell)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 2,
                            left: 2,
                            bottom: 2,
                            right: 2)
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 2
    }
}

