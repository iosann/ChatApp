//
//  ActivityIndicator.swift
//  ChatApp
//
//  Created by Anna Belousova on 27.04.2022.
//

import UIKit

class ActivityIndicator: UIActivityIndicatorView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        style = .large
        color = .black
        hidesWhenStopped = true
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension ActivityIndicator {
    
    func animate() {
        UIView.animate(withDuration: 0.3, delay: 0, options: [.autoreverse, .repeat, .curveEaseOut]) {
            self.transform = CGAffineTransform(scaleX: 1.5, y: 1.5)
        } completion: { _ in
            print("finish animate")
        }
    }
}
