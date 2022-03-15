//
//  ViewController.swift
//  ChatApp
//
//  Created by Anna Belousova on 20.02.2022.
//

import UIKit

class ViewController: UIViewController {
    
    private lazy var openProfileButton: UIButton = {
        let button = UIButton()
        button.frame.size = CGSize(width: 150, height: 50)
        button.center = self.view.center
        button.setTitle("Open profile", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.layer.cornerRadius = 8
        button.layer.borderColor = UIColor.black.cgColor
        button.layer.borderWidth = 2
        button.addTarget(self, action: #selector(openProfile), for: .touchUpInside)
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        view.addSubview(openProfileButton)
        NSLog(#function)
    }
    
    @objc private func openProfile() {
        let profileViewController = ProfileViewController()
        let navigationController = UINavigationController(rootViewController: profileViewController)
        self.present(navigationController, animated: true)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        NSLog(#function)
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        NSLog(#function)
    }

    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        NSLog(#function)
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        NSLog(#function)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NSLog(#function)
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        NSLog(#function)
    }
}

