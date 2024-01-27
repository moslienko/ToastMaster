//
//  DisplayConfig.swift
//  
//
//  Created by Pavel Moslienko on 27.01.2024.
//

import Foundation
import UIKit

public struct DisplayConfig {

    public var position: ToastPosition = .bottom
    
    public static func makeDefaultConfig() -> DisplayConfig {
        DisplayConfig()
    }
}
