//
//  IconConfig.swift
//  
//
//  Created by Pavel Moslienko on 24.01.2024.
//

import Foundation
import UIKit

public struct IconConfig {
    var size: CGSize
    var renderingMode: UIImage.RenderingMode
    var tintColor: UIColor

    public static func makeDefaultConfig() -> IconConfig {
        IconConfig(
            size: CGSize(width: 28.0, height: 28.0),
            renderingMode: .alwaysTemplate,
            tintColor: .white
        )
    }
}
