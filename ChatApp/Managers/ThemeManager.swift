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
        UserDefaults.standard.set(currentTheme.rawValue, forKey: "CurrentTheme")
    }
    
    func applyTheme(theme: ColorTheme) {
        currentTheme = theme
    }
    
    func setBackgroundColor(for view: UIView) {
        view.backgroundColor = currentTheme.backgroundColor
    }
    
    func setBackgroundColorForIncomingMessage(for view: UIView) {
        view.backgroundColor = currentTheme.incomingMessageColor
    }
    
    func setBackgroundColorForOutgoingMessage(for view: UIView) {
        view.backgroundColor = currentTheme.outgoingMessageColor
    }
}






