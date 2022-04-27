//
//  ImagesCollectionViewController.swift
//  ChatApp
//
//  Created by Anna Belousova on 22.04.2022.
//

import UIKit

private let reuseIdentifier = "Cell"

class ImagesCollectionViewController: UICollectionViewController {
    
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
        loadImages()
    }
    
    private func loadImages() {
        model?.getImagesURL { [weak self] result in
            switch result {
            case .success(let imagesURL):
                self?.images = imagesURL
                DispatchQueue.main.async {
                    self?.collectionView.reloadData()
                }
            case .failure(let error):
                assertionFailure(error.localizedDescription)
            }
        }
    }

    // MARK: UICollectionViewDataSource

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return images.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as? ImageCollectionViewCell
        cell?.imageView.backgroundColor = .red
        print(images[indexPath.row])
        return cell ?? UICollectionViewCell()
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
