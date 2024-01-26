//
//  ToastConfig.swift
//  
//
//  Created by Pavel Moslienko on 25.01.2024.
//

import Foundation
import UIKit

public struct ToastConfig {
    var layout: ToastLayout
    var iconConfig: IconConfig
    var textConfig: TextContentStyleConfig
    var buttonConfig: TextElementConfig
    
    public init(
        layout: ToastLayout = .vertical,
        iconConfig: IconConfig = IconConfig.makeDefaultConfig(),
        textConfig: TextContentStyleConfig = TextContentStyleConfig.makeDefaultConfig(),
        buttonConfig: TextElementConfig? = nil
    ) {
        self.layout = layout
        self.iconConfig = iconConfig
        self.textConfig = textConfig
        self.buttonConfig = buttonConfig ?? TextElementConfig.makeDefaultButtonConfig(layout: layout)
    }
}
