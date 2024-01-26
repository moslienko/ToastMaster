//
//  TextContentStyleConfig.swift
//  
//
//  Created by Pavel Moslienko on 24.01.2024.
//

import Foundation
import UIKit

public struct TextContentStyleConfig {
    var header: TextStyleConfig
    var message: TextStyleConfig
    
    public static func makeDefaultConfig() -> TextContentStyleConfig {
        TextContentStyleConfig(
            header: TextStyleConfig.makeDefaultHeaderConfig(),
            message: TextStyleConfig.makeDefaultMessageConfig()
        )
    }
}
