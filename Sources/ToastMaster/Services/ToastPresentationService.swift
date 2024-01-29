//
//  ToastPresentationService.swift
//  
//
//  Created by Pavel Moslienko on 29.01.2024.
//

import Foundation
import UIKit

public protocol ToastPresentable {
    func present()
    func dissmiss(withAnimation: Bool)
    
    var didToastPresented: (() -> Void)? { get }
}

public class ToastPresentationService: ToastPresentable {
    
    private var toastContainer: UIView
    private var config: ToastConfig
    
    public var didToastPresented: (() -> Void)?
    
    public init(container: UIView, config: ToastConfig) {
        self.toastContainer = container
        self.config = config
    }
    
    public func present() {
        self.toastContainer.layoutIfNeeded()
        var initialFrame: CGRect {
            switch self.config.displayConfig.position {
            case .top:
                return CGRect(
                    x: 0,
                    y:  -self.toastContainer.frame.height,
                    width: UIScreen.main.bounds.width,
                    height: self.toastContainer.frame.height
                )
            case .bottom:
                return CGRect(
                    x: 0,
                    y: UIScreen.main.bounds.height,
                    width: UIScreen.main.bounds.width,
                    height: self.toastContainer.frame.height
                )
            }
        }
        
        self.toastContainer.frame = initialFrame
        self.toastContainer.alpha = 0.0
        
        var finalFrame: CGRect {
            switch self.config.displayConfig.position {
            case .top:
                return CGRect(
                    x: 0,
                    y: 0,
                    width: UIScreen.main.bounds.width,
                    height: self.toastContainer.frame.height
                )
            case .bottom:
                return CGRect(
                    x: 0,
                    y: UIScreen.main.bounds.height - self.toastContainer.frame.height,
                    width: UIScreen.main.bounds.width,
                    height: self.toastContainer.frame.height
                )
            }
        }
        
        UIView.animate(
            withDuration: self.config.displayConfig.animationDuration,
            delay: 0.0,
            options: .curveEaseIn,
            animations: {
                self.toastContainer.frame = finalFrame
                self.toastContainer.alpha = 1.0
            },
            completion: { _ in
                self.didToastPresented?()
            }
        )
    }
    
    public func dissmiss(withAnimation: Bool) {
        if withAnimation {
            UIView.animate(
                withDuration: self.config.displayConfig.animationDuration,
                delay: 0.0,
                options: .curveEaseOut,
                animations: {
                    switch self.config.displayConfig.position {
                    case .top:
                        self.toastContainer.frame.origin.y = 0.0
                    case .bottom:
                        self.toastContainer.frame.origin.y += self.toastContainer.frame.height
                    }
                    self.toastContainer.alpha = 0.0
                },
                completion: { _ in
                    self.toastContainer.removeFromSuperview()
                }
            )
        } else {
            self.toastContainer.removeFromSuperview()
        }
        
        ToastView.shared.dismissWorkItem?.cancel()
    }
}
