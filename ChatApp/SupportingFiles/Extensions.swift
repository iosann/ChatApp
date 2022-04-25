//
//  Extensions.swift
//  ChatApp
//
//  Created by Anna Belousova on 23.02.2022.
//

import UIKit

extension UIApplication.State {
    
    var name: String {
        switch self {
        case .active: return "active"
        case .inactive: return "inactive"
        case .background: return "background"
        @unknown default: return ""
        }
    }
}

extension Date {
    var formattedDate: String {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "en_US_POSIX")
        if Calendar.current.isDateInToday(self) {
            formatter.dateFormat = "HH:mm"
        } else { formatter.dateFormat = "dd MMM" }
        return formatter.string(from: self)
    }
}

extension String {
    var formattedDate: Date? {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        return formatter.date(from: self)
    }
}

extension UIView {
    func asImage() -> UIImage {
        let renderer = UIGraphicsImageRenderer(bounds: bounds)
        return renderer.image { rendererContext in
            layer.render(in: rendererContext.cgContext)
        }
    }
    
    func addActivityIndicator() -> UIActivityIndicatorView {
        let activityIndicator = UIActivityIndicatorView()
        activityIndicator.style = .large
        activityIndicator.color = .black
        activityIndicator.hidesWhenStopped = true
        activityIndicator.center = self.center
        self.addSubview(activityIndicator)
        return activityIndicator
    }
}

extension UIButton {
    
    func centerVertically(padding: CGFloat) {
        guard let imageViewSize = self.imageView?.frame.size,
              let titleLabelSize = self.titleLabel?.frame.size
        else { return }
        let totalHeight = imageViewSize.height + titleLabelSize.height + padding
        self.imageEdgeInsets = UIEdgeInsets(top: -(totalHeight - imageViewSize.height), left: 0, bottom: 0, right: -titleLabelSize.width)
        self.titleEdgeInsets = UIEdgeInsets(top: 0, left: -imageViewSize.width, bottom: -(totalHeight - titleLabelSize.height), right: 0)
    }
}
