//
//  ProfileViewController.swift
//  ChatApp
//
//  Created by Anna Belousova on 03.03.2022.
//

import UIKit

class ProfileViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    private func setupUI() {
        navigationController?.navigationBar.backgroundColor = .white
        navigationController?.navigationBar.largeTitleTextAttributes = [.font: UIFont(name: "SFProDisplay-Bold", size: 26)]
        navigationController?.navigationBar.prefersLargeTitles = true
        title = "My Profile"
        let closeButton = UIBarButtonItem(title: "Close", style: .plain, target: self, action: #selector(closeTheScreen))
        navigationItem.rightBarButtonItem = closeButton
        
        view.backgroundColor = .blue
    }
    
    @objc private func closeTheScreen() {
        dismiss(animated: true, completion: nil)
    }
}
