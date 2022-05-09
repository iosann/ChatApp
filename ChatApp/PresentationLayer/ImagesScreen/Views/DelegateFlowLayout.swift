//
//  DelegateFlowLayout.swift
//  ChatApp
//
//  Created by Anna Belousova on 10.05.2022.
//

import UIKit

extension ImagesCollectionViewController: UICollectionViewDelegateFlowLayout {
    
    enum SizeConstants: CGFloat {
        case spacing = 16
        case numberOfItemsInRow = 3
        case sumOfCellSpacingInRow = 64
    }
    
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
