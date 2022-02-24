//
//  ViewController.swift
//  ChatApp
//
//  Created by Anna Belousova on 20.02.2022.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        NSLog(#function)
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

