//
//  ContainerConfig.swift
//  
//
//  Created by Pavel Moslienko on 27.01.2024.
//

import Foundation
import UIKit

public struct ContainerConfig {
    public var backgroundColor: UIColor
    public var cornerRadius: CGFloat
    public var isNeedBlur: Bool
    public var blurStyle: UIBlurEffect.Style?

    public static func makeDefaultConfig() -> ContainerConfig {
        ContainerConfig(
            backgroundColor: UIColor(red: 0.175, green: 0.175, blue: 0.175, alpha: 0.8),
            cornerRadius: 16.0,
            isNeedBlur: false,
            blurStyle: nil
        )
    }
}
