//
//  ThemeManager.swift
//  ChatApp
//
//  Created by Anna Belousova on 17.03.2022.
//

import UIKit

protocol IThemeManager: AnyObject {
    var theme: ColorTheme? { get set }
}
    
final class ThemeManager: IThemeManager {

    var selectedThemeComplition: ((ColorTheme) -> Void)?
    var theme: ColorTheme? {
        didSet { Self.currentTheme = theme }
    }

    static var saved: ColorTheme {
        let storedThemeNumber = UserDefaults.standard.integer(forKey: "CurrentTheme")
        return ColorTheme(rawValue: storedThemeNumber) ?? .classic
    }
    
    static var currentTheme: ColorTheme? = saved {
        didSet { Self.apply() }
    }
    
    static func apply() {
        UIApplication.shared.delegate?.window??.tintColor = currentTheme?.tintColor
        UIApplication.shared.delegate?.window??.backgroundColor = currentTheme?.backgroundColor
        UITableView.appearance().backgroundColor = currentTheme?.backgroundColor
        UINavigationBar.appearance().titleTextAttributes = [.foregroundColor: currentTheme?.tintColor as Any]
    }
    
    static func save() {
        DispatchQueue.global(qos: .utility).async {
            UserDefaults.standard.set(Self.currentTheme?.rawValue, forKey: "CurrentTheme")
        }
    }
}
