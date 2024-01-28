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
    public var containerConfig: ContainerConfig
    public var displayConfig: DisplayConfig
    public var iconConfig: IconConfig
    public var textConfig: TextContentStyleConfig
    public var buttonConfig: TextElementConfig
    
    public init(
        layout: ToastLayout = .vertical,
        containerConfig: ContainerConfig = ContainerConfig(),
        displayConfig: DisplayConfig = DisplayConfig(),
        iconConfig: IconConfig = IconConfig(),
        textConfig: TextContentStyleConfig = TextContentStyleConfig(),
        buttonConfig: TextElementConfig? = nil
    ) {
        self.layout = layout
        self.containerConfig = containerConfig
        self.displayConfig = displayConfig
        self.iconConfig = iconConfig
        self.textConfig = textConfig
        self.buttonConfig = buttonConfig ?? TextElementConfig.makeDefaultButtonConfig(layout: layout)
    }
}
