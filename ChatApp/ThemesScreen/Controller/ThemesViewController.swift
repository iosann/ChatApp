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
    private let myView = ButtonThemesView(frame: CGRect(x: 0, y: 0, width: 300, height: 70))
    
    private weak var delegate: ChangeThemeProtocol?
    private let themeManager = ThemeManager.shared
//    var selectedTheme: ((Theme) -> ())?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Settings"
        navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: ThemeManager.shared.current.tintColor]
        self.delegate = themeManager
        ThemeManager.shared.setBackgroundColor(for: view)
        view.addSubview(myView)
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(cancelScreen))
        customizeButtons()
        
        for (theme, button) in zip(ColorTheme.allCases, buttons) {
            setButtonImage(backgroundColor: theme.backgroundColor, incomingMessageColor: theme.incomingMessageColor, outgoingMessageColor: theme.outgoingMessageColor, forButton: button)
            button.setTitle(theme.name, for: .normal)
            button.tag = theme.rawValue
            button.centerVertically(padding: 15)
        }
        myView.removeFromSuperview()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if self.isMovingFromParent {
            ThemeManager.shared.save()
        }
    }
    
    private func setButtonImage(backgroundColor: UIColor, incomingMessageColor: UIColor, outgoingMessageColor: UIColor, forButton button: UIButton) {
        myView.setColors(backgroundColor: backgroundColor, incomingMessageColor: incomingMessageColor, outgoingMessageColor: outgoingMessageColor)
        let image = myView.asImage()
        button.setImage(image, for: .normal)
        button.imageView?.layer.borderColor = UIColor.blue.cgColor
        button.imageView?.layer.borderWidth = 0
        button.imageView?.layer.cornerRadius = 10
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
                $0.heightAnchor.constraint(equalToConstant: 105),
                $0.centerXAnchor.constraint(equalTo: view.centerXAnchor)
            ])
       }
        NSLayoutConstraint.activate([
            middleButton.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            topButton.bottomAnchor.constraint(equalTo: middleButton.topAnchor, constant: -40),
            bottomButton.topAnchor.constraint(equalTo: middleButton.bottomAnchor, constant: 40)
        ])
    }
    
    @objc private func chooseTheme(_ sender: UIButton) {
        let selectedTheme = ColorTheme(rawValue: sender.tag)!
        buttons.forEach {
            $0.imageView?.layer.borderWidth = 1
            $0.imageView?.layer.borderColor = UIColor.black.cgColor
        }
        sender.imageView?.layer.borderWidth = 3
        sender.imageView?.layer.borderColor = UIColor.blue.cgColor
        view.backgroundColor = selectedTheme.backgroundColor
        delegate?.applyTheme(theme: selectedTheme)
    }
    
    @objc private func cancelScreen() {
        delegate?.applyTheme(theme: ThemeManager.saved)
        ThemeManager.shared.setBackgroundColor(for: view)
        navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: ThemeManager.shared.current.tintColor]
    }
}
