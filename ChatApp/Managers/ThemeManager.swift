//
//  ThemeManager.swift
//  ChatApp
//
//  Created by Anna Belousova on 17.03.2022.
//

import UIKit

//    var selectedTheme: ((Theme) -> ())?

protocol ChangeThemeProtocol: AnyObject {
    func applyTheme(theme: ColorTheme)
}
    
class ThemeManager: ChangeThemeProtocol {
    
    static let shared = ThemeManager(savedTheme: ThemeManager.saved)
    
    private init(savedTheme: ColorTheme) {
        self.current = savedTheme
    }

    static var saved: ColorTheme {
        let storedThemeNumber = UserDefaults.standard.integer(forKey: "CurrentTheme")
        return ColorTheme(rawValue: storedThemeNumber) ?? .classic
    }
    
    var current: ColorTheme {
        didSet { apply() }
    }
    
    func apply() {
        UIApplication.shared.delegate?.window??.tintColor = current.tintColor
//        UINavigationBar.appearance().barStyle = current.barStyle
        UITableView.appearance().backgroundColor = current.backgroundColor
        UINavigationBar.appearance().titleTextAttributes = [.foregroundColor: current.tintColor]
    }
    
    func save() {
        UserDefaults.standard.set(current.rawValue, forKey: "CurrentTheme")
    }
    
    func applyTheme(theme: ColorTheme) {
        current = theme
    }
    
    func setBackgroundColor(for view: UIView) {
        view.backgroundColor = current.backgroundColor
    }
    
    func setBackgroundColorForIncomingMessage(for view: UIView) {
        view.backgroundColor = current.incomingMessageColor
    }
    
    func setBackgroundColorForOutgoingMessage(for view: UIView) {
        view.backgroundColor = current.outgoingMessageColor
    }
}
