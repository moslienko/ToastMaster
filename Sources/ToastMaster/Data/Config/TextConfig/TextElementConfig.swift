//
//  TextElementConfig.swift
//  
//
//  Created by Pavel Moslienko on 26.01.2024.
//

import Foundation
import UIKit

public struct TextElementConfig {
    var font: UIFont
    var color: UIColor
    
    private static var headerFont = UIFont.systemFont(ofSize: 14, weight: .semibold)
    private static var messageFont = UIFont.systemFont(ofSize: 14, weight: .regular)
    private static var horizontalButtonFont = UIFont.systemFont(ofSize: 17, weight: .regular)
    private static var textColor = UIColor.white
    private static var linkColor = UIColor(red: 0.35, green: 0.78, blue: 0.98, alpha: 1)
    
    public static func makeDefaultHeaderConfig() -> TextElementConfig {
        TextElementConfig(font: headerFont, color: textColor)
    }
    
    public static func makeDefaultMessageConfig() -> TextElementConfig {
        TextElementConfig(font: messageFont, color: linkColor)
    }
    
    public static func makeDefaultHeaderLinkConfig() -> TextElementConfig {
        TextElementConfig(font: headerFont, color: linkColor)
    }
    
    public static func makeDefaultMessageLinkConfig() -> TextElementConfig {
        TextElementConfig(font: messageFont, color: linkColor)
    }
    
    public static func makeDefaultButtonConfig(layout: ToastLayout) -> TextElementConfig {
        switch layout {
        case .horozintal:
            return TextElementConfig(font: horizontalButtonFont, color: linkColor)
        case .vertical:
            return TextElementConfig(font: messageFont, color: linkColor)
        }
    }
}
