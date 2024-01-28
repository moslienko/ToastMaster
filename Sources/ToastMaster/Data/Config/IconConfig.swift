//
//  IconConfig.swift
//  
//
//  Created by Pavel Moslienko on 24.01.2024.
//

import Foundation
import UIKit

public struct IconConfig {
    public var size: CGSize
    public var renderingMode: UIImage.RenderingMode
    public var tintColor: UIColor

    public init(
        size: CGSize = CGSize(width: 28.0, height: 28.0),
        renderingMode: UIImage.RenderingMode = .alwaysTemplate,
        tintColor: UIColor = .white
    ) {
        self.size = size
        self.renderingMode = renderingMode
        self.tintColor = tintColor
    }
}
