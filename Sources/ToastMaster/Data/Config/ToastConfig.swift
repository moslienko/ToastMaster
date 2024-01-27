//
//  ToastConfig.swift
//  
//
//  Created by Pavel Moslienko on 25.01.2024.
//

import Foundation
import UIKit

public struct ToastConfig {
    public var layout: ToastLayout
    public var iconConfig: IconConfig
    public var textConfig: TextContentStyleConfig
    public var buttonConfig: TextElementConfig
    
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
