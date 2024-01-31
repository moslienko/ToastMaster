//
//  DisplayConfig.swift
//  
//
//  Created by Pavel Moslienko on 27.01.2024.
//

import Foundation
import UIKit

/// Config defining positioning of toast on the screen during displaying
public struct DisplayConfig {
    public var position: ToastPosition
    public var toastDuration: DispatchTimeInterval
    public var animationDuration: TimeInterval

    public init(
        position: ToastPosition = .bottom,
        toastDuration: DispatchTimeInterval = .seconds(5),
        animationDuration: TimeInterval = 0.5
    ) {
        self.position = position
        self.toastDuration = toastDuration
        self.animationDuration = animationDuration
    }
}
