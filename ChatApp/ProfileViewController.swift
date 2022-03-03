//
//  ProfileViewController.swift
//  ChatApp
//
//  Created by Anna Belousova on 03.03.2022.
//

import UIKit

class ProfileViewController: UIViewController {
    
    private let profileView = BaseProfileView()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    private func setupUI() {
        navigationController?.navigationBar.backgroundColor = UIColor(red: 0.968, green: 0.968, blue: 0.968, alpha: 1)
        navigationController?.navigationBar.largeTitleTextAttributes = [.font: UIFont(name: "SFProDisplay-Bold", size: 26) ?? .boldSystemFont(ofSize: 26)]
        navigationController?.navigationBar.prefersLargeTitles = true
        title = "My Profile"
        let closeButton = UIBarButtonItem(title: "Close", style: .plain, target: self, action: #selector(closeTheScreen))
        navigationItem.rightBarButtonItem = closeButton

        view = profileView
    }
    
    @objc private func closeTheScreen() {
        dismiss(animated: true, completion: nil)
    }
}
