//
//  TextStyleConfig.swift
//  
//
//  Created by Pavel Moslienko on 26.01.2024.
//

import Foundation

/// Config to set the style for plain text, and for links
public struct TextStyleConfig {
    var regularText: TextElementConfig
    var linkText: TextElementConfig
    
    public static func makeDefaultHeaderConfig() -> TextStyleConfig {
        TextStyleConfig(
            regularText: TextElementConfig.makeDefaultHeaderConfig(),
            linkText: TextElementConfig.makeDefaultHeaderLinkConfig()
        )
    }
    
    public static func makeDefaultMessageConfig() -> TextStyleConfig {
        TextStyleConfig(
            regularText: TextElementConfig.makeDefaultMessageConfig(),
            linkText: TextElementConfig.makeDefaultMessageLinkConfig()
        )
    }
}
