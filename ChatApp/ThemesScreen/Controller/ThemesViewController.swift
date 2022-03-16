//
//  ThemesViewController.swift
//  ChatApp
//
//  Created by Anna Belousova on 16.03.2022.
//

import UIKit

class ThemesViewController: UIViewController {
    
    private let topButton = UIButton()
    private let middleButton = UIButton()
    private let bottomButton = UIButton()
    private lazy var buttons = [topButton, middleButton, bottomButton]
    private let myView = ButtonThemesView(frame: CGRect(x: 0, y: 0, width: 300, height: 60))
    private let themes = ColorTheme.allThemes

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Settings"
        view.backgroundColor = .red
        view.addSubview(myView)
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(cancelScreen))
        customizeButtons()
        
        for (theme, button) in zip(themes, buttons) {
            setButtonImage(backgroundColor: theme.backgroundColor, incomingMessageColor: theme.incomingMessageColor, outgoingMessageColor: theme.outgoingMessageColor, forButton: button)
            button.setTitle(theme.name, for: .normal)
            button.centerVertically(padding: 15)
        }
        myView.removeFromSuperview()
    }
    
    private func setButtonImage(backgroundColor: UIColor, incomingMessageColor: UIColor, outgoingMessageColor: UIColor, forButton button: UIButton) {
        myView.setColors(backgroundColor: backgroundColor, incomingMessageColor: incomingMessageColor, outgoingMessageColor: outgoingMessageColor)
        let image = myView.asImage()
        button.setImage(image, for: .normal)
    }

    private func customizeButtons() {
        buttons.forEach {
            view.addSubview($0)
            $0.addTarget(self, action: #selector(chooseTheme), for: .touchUpInside)
            $0.titleLabel?.font = .boldSystemFont(ofSize: 22)
            $0.setTitleColor(.white, for: .normal)
            $0.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                $0.widthAnchor.constraint(equalToConstant: 300),
                $0.heightAnchor.constraint(equalToConstant: 60),
                $0.centerXAnchor.constraint(equalTo: view.centerXAnchor)
            ])
       }
        NSLayoutConstraint.activate([
            middleButton.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            topButton.bottomAnchor.constraint(equalTo: middleButton.topAnchor, constant: -70),
            bottomButton.topAnchor.constraint(equalTo: middleButton.bottomAnchor, constant: 70)
        ])
    }
    
    @objc private func chooseTheme(_ sender: UIButton) {
        print(sender, "button tapped")
    }
    
    @objc private func cancelScreen() {

    }
}
