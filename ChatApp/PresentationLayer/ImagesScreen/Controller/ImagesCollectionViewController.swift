//
//  ImagesCollectionViewController.swift
//  ChatApp
//
//  Created by Anna Belousova on 22.04.2022.
//

import UIKit

class ImagesCollectionViewController: UICollectionViewController {
    
    enum SizeConstants: CGFloat {
        case spacing = 16
        case numberOfItemsInRow = 3
        case sumOfCellSpacingInRow = 64
    }
    
    private let reuseIdentifier = "Cell"
    private lazy var activityIndicator = ActivityIndicator(frame: .zero)
    private let model: IImagesModel
    private var imagesURL = [String]()
    var didUpdateCompletion: ((String) -> Void)?
    
    init(model: IImagesModel, presentationAssembly: IPresentationAssembly) {
        self.model = model
        super.init(collectionViewLayout: UICollectionViewFlowLayout())
    }
    required init?(coder: NSCoder) {
          fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.collectionView?.register(ImageCollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        collectionView.addSubview(activityIndicator)
        activityIndicator.center = collectionView.center
        loadImages()
    }
    
    private func loadImages() {
        activityIndicator.startAnimating()
        model.getImagesURL { [weak self] result in
            switch result {
            case .success(let response):
                response.hits.forEach {
                    if let largeImageURL = $0.largeImageURL { self?.imagesURL.append(largeImageURL) }
                }
                DispatchQueue.main.async {
                    self?.collectionView.reloadData()
                    self?.activityIndicator.stopAnimating()
                }
            case .failure(let error):
                DispatchQueue.main.async {
                    self?.activityIndicator.stopAnimating()
                    assertionFailure(error.localizedDescription)
                }
            }
        }
    }

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return imagesURL.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as? ImageCollectionViewCell
        model.getImage(from: imagesURL[indexPath.row]) { result in
            switch result {
            case .success(let image):
                DispatchQueue.main.async {
                    cell?.imageView.image = image
                }
            case .failure(let error):
                NSLog(error.localizedDescription)
            }
        }
        return cell ?? UICollectionViewCell()
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        didUpdateCompletion?(imagesURL[indexPath.row])
        dismiss(animated: true)
    }
}

extension ImagesCollectionViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: (UIScreen.main.bounds.width - SizeConstants.sumOfCellSpacingInRow.rawValue) / SizeConstants.numberOfItemsInRow.rawValue,
                      height: (UIScreen.main.bounds.width - SizeConstants.sumOfCellSpacingInRow.rawValue) / SizeConstants.numberOfItemsInRow.rawValue)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout,
                        insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: SizeConstants.spacing.rawValue,
                            left: SizeConstants.spacing.rawValue,
                            bottom: SizeConstants.spacing.rawValue,
                            right: SizeConstants.spacing.rawValue)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return SizeConstants.spacing.rawValue
    }
}
