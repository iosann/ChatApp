//
//  ImagesCollectionViewController.swift
//  ChatApp
//
//  Created by Anna Belousova on 22.04.2022.
//

import UIKit

class ImagesCollectionViewController: UICollectionViewController {
    
    private let reuseIdentifier = "Cell"
    private lazy var activityIndicator = ActivityIndicator(frame: .zero)
    private let model: IImagesModel? = ImagesModel()
    private var images = [String]()
    
    init() {
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
        model?.getImagesURL { [weak self] result in
            switch result {
            case .success(let imagesURL):
                self?.images = imagesURL
                DispatchQueue.main.async {
                    self?.collectionView.reloadData()
                    self?.activityIndicator.stopAnimating()
                }
            case .failure(let error):
                assertionFailure(error.localizedDescription)
                DispatchQueue.main.async {
                    self?.activityIndicator.stopAnimating()
                }
            }
        }
    }

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return images.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as? ImageCollectionViewCell
        model?.getImage(from: images[indexPath.row]) { result in
            switch result {
            case .success(let image):
                DispatchQueue.main.async {
                    cell?.imageView.image = image
                }
            case .failure(let error):
                assertionFailure(error.localizedDescription)
            }
        }
        return cell ?? UICollectionViewCell()
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let selectedImageURL = images[indexPath.row]
// save image
        dismiss(animated: true)
    }
}

extension ImagesCollectionViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: (UIScreen.main.bounds.width - 64) / 3, height: (UIScreen.main.bounds.width - 64) / 3)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout,
                        insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 16, left: 16, bottom: 16, right: 16)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 16
    }
}
