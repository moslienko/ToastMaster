//
//  TextContentStyleConfig.swift
//  
//
//  Created by Pavel Moslienko on 24.01.2024.
//

import Foundation
import UIKit

/// Common config for header and message styles
public struct TextContentStyleConfig {
    var header: TextStyleConfig
    var message: TextStyleConfig
    
    public init(
        header: TextStyleConfig = TextStyleConfig.makeDefaultHeaderConfig(),
        message: TextStyleConfig = TextStyleConfig.makeDefaultMessageConfig()
    ) {
        self.header = header
        self.message = message
    }
}
