//
//  ContainerConfig.swift
//  
//
//  Created by Pavel Moslienko on 27.01.2024.
//

import Foundation
import UIKit

/// Settings for defining the toast container style
public struct ContainerConfig {
    public var backgroundColor: UIColor
    public var cornerRadius: CGFloat
    public var insets: UIEdgeInsets
    public var isNeedBlur: Bool
    public var blurStyle: UIBlurEffect.Style?

    public init(
        backgroundColor: UIColor = UIColor(red: 0.175, green: 0.175, blue: 0.175, alpha: 0.8),
        cornerRadius: CGFloat = 16.0,
        insets: UIEdgeInsets = UIEdgeInsets(top: 0.0, left: 16.0, bottom: 0.0, right: -16.0),
        isNeedBlur: Bool = false,
        blurStyle: UIBlurEffect.Style? = nil
    ) {
       self.backgroundColor = backgroundColor
       self.cornerRadius = cornerRadius
       self.insets = insets
       self.isNeedBlur = isNeedBlur
       self.blurStyle = blurStyle
   }
}
