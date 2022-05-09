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
//    private let themeManager = ThemeManager()
    private weak var delegate: IThemeManager?
    
    init(delegate: IThemeManager?) {
        self.delegate = delegate
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Settings"
//        themeManager.selectedThemeComplition = { [weak self] theme in
//            self?.setTheme(theme: theme)
//        }
        setColors(theme: ThemeManager.currentTheme)
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
        buttons[ThemeManager.currentTheme?.rawValue ?? 0].imageView?.layer.borderColor = UIColor.blue.cgColor
        buttons[ThemeManager.currentTheme?.rawValue ?? 0].imageView?.layer.borderWidth = 3
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if self.isMovingFromParent {
            ThemeManager.save()
        }
    }
    
    private func setTheme(theme: ColorTheme) {
        ThemeManager.currentTheme = theme
    }
    
    private func setButtonImage(backgroundColor: UIColor, incomingMessageColor: UIColor, outgoingMessageColor: UIColor, forButton button: UIButton) {
        myView.setColors(backgroundColor: backgroundColor, incomingMessageColor: incomingMessageColor, outgoingMessageColor: outgoingMessageColor)
        let image = myView.asImage()
        button.setImage(image, for: .normal)
        button.imageView?.layer.cornerRadius = 10
    }

    private func customizeButtons() {
        buttons.forEach {
            view.addSubview($0)
            $0.addTarget(self, action: #selector(chooseTheme), for: .touchUpInside)
            $0.titleLabel?.font = .boldSystemFont(ofSize: 22)
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
        setColors(theme: selectedTheme)
        sender.imageView?.layer.borderWidth = 3
        sender.imageView?.layer.borderColor = UIColor.blue.cgColor
        delegate?.theme = selectedTheme
//        themeManager.selectedThemeComplition?(selectedTheme ?? .classic)
    }
    
    @objc private func cancelScreen() {
        delegate?.theme = ThemeManager.saved
 //       themeManager.selectedThemeComplition?(ThemeManager.saved)
        setColors(theme: ThemeManager.saved)
        buttons[ThemeManager.saved.rawValue].imageView?.layer.borderWidth = 3
        buttons[ThemeManager.saved.rawValue].imageView?.layer.borderColor = UIColor.blue.cgColor
    }
    
    private func setColors(theme: ColorTheme?) {
        buttons.forEach {
            $0.setTitleColor(theme?.textColor, for: .normal)
            $0.imageView?.layer.borderWidth = 1
            $0.imageView?.layer.borderColor = theme?.textColor.cgColor
        }
        view.backgroundColor = theme?.backgroundColor
        navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: theme?.tintColor ?? UIColor.black]
    }
}
