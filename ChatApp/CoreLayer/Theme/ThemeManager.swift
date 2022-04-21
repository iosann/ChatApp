//
//  ThemeManager.swift
//  ChatApp
//
//  Created by Anna Belousova on 17.03.2022.
//

import UIKit

protocol ChangeThemeProtocol: AnyObject {
    var currentTheme: ColorTheme { get set }
}
    
class ThemeManager: ChangeThemeProtocol {

    static let shared = ThemeManager(savedTheme: ThemeManager.saved)
    var selectedThemeComplition: ((ColorTheme) -> Void)?
    
    private init(savedTheme: ColorTheme) {
        self.currentTheme = savedTheme
    }

    static var saved: ColorTheme {
        let storedThemeNumber = UserDefaults.standard.integer(forKey: "CurrentTheme")
        return ColorTheme(rawValue: storedThemeNumber) ?? .classic
    }
    
    var currentTheme: ColorTheme {
        didSet { apply() }
    }
    
    func apply() {
        UIApplication.shared.delegate?.window??.tintColor = currentTheme.tintColor
        UITableView.appearance().backgroundColor = currentTheme.backgroundColor
        UINavigationBar.appearance().titleTextAttributes = [.foregroundColor: currentTheme.tintColor]
    }
    
    func save() {
        DispatchQueue.global(qos: .utility).async { [weak self] in
            UserDefaults.standard.set(self?.currentTheme.rawValue, forKey: "CurrentTheme")
        }
    }
}
