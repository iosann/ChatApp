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
    
    // сильная ссылка на делегат может создать retain cycle
    private weak var delegate: ChangeThemeProtocol?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Settings"
        navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.black]
        self.delegate = ThemeManager.shared
        // захват сильной ссылки на self (ThemesViewController) может создать retain cycle,
        // при котором ThemeManager будет держать ссылку на ThemesViewController и не даст ему деинициализироваться
        ThemeManager.shared.selectedThemeComplition = { [weak self] theme in
            self?.setTheme(theme: theme)
        }
        ThemeManager.shared.setBackgroundColor(for: view)
        view.addSubview(myView)
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(cancelScreen))
        customizeButtons()
        
        for (theme, button) in zip(ColorTheme.allCases, buttons) {
            setButtonImage(backgroundColor: theme.backgroundColor,
                           incomingMessageColor: theme.incomingMessageColor,
                           outgoingMessageColor: theme.outgoingMessageColor,
                           forButton: button)
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
    
    private func setTheme(theme: ColorTheme) {
        ThemeManager.shared.currentTheme = theme
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
            $0.setTitleColor(.black, for: .normal)
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
        let selectedTheme = ColorTheme(rawValue: sender.tag)
        buttons.forEach {
            $0.imageView?.layer.borderWidth = 1
            $0.imageView?.layer.borderColor = UIColor.black.cgColor
        }
        sender.imageView?.layer.borderWidth = 3
        sender.imageView?.layer.borderColor = UIColor.blue.cgColor
        view.backgroundColor = selectedTheme?.backgroundColor
 //       delegate?.currentTheme = selectedTheme
        ThemeManager.shared.selectedThemeComplition?(selectedTheme ?? .classic)
    }
    
    @objc private func cancelScreen() {
//        delegate?.currentTheme = ThemeManager.saved
        ThemeManager.shared.selectedThemeComplition?(ThemeManager.saved)
        ThemeManager.shared.setBackgroundColor(for: view)
    }
}
