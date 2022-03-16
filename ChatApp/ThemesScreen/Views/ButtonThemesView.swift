//
//  ButtonThemesView.swift
//  ChatApp
//
//  Created by Anna Belousova on 16.03.2022.
//

import UIKit

class ButtonThemesView: UIView {
    
    let incomingView = UIView()
    let outgoingView = UIView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupConstraints()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setColors(backgroundColor: UIColor?, incomingMessageColor: UIColor?, outgoingMessageColor: UIColor?) {
        self.backgroundColor = backgroundColor
        incomingView.backgroundColor = incomingMessageColor
        outgoingView.backgroundColor = outgoingMessageColor
    }
    
    private func setupConstraints() {
        addSubview(incomingView)
        addSubview(outgoingView)
        incomingView.translatesAutoresizingMaskIntoConstraints = false
        outgoingView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            incomingView.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 0.35),
            incomingView.heightAnchor.constraint(equalTo: self.heightAnchor, multiplier: 0.4),
            incomingView.trailingAnchor.constraint(equalTo: self.centerXAnchor, constant: -10),
            incomingView.topAnchor.constraint(equalTo: self.topAnchor, constant: 10),
            
            outgoingView.widthAnchor.constraint(equalTo: incomingView.widthAnchor),
            outgoingView.heightAnchor.constraint(equalTo: incomingView.heightAnchor),
            outgoingView.leadingAnchor.constraint(equalTo: self.centerXAnchor, constant: 10),
            outgoingView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -10)
        ])
        layer.cornerRadius = 10
        incomingView.layer.cornerRadius = 5
        outgoingView.layer.cornerRadius = 5
    }
}
