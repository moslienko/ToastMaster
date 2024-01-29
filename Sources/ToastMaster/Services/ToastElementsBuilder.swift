//
//  ToastElementsBuilder.swift
//  
//
//  Created by Pavel Moslienko on 29.01.2024.
//

import Foundation
import UIKit

public protocol ToastElementsMaker {    
    func createIconImageView(icon: UIImage?) -> UIImageView
    func createHeaderTextView(header: String?, delegate: UITextViewDelegate) -> UITextView
    func createMessageTextView(message: String?, delegate: UITextViewDelegate) -> UITextView
}

public class ToastElementsBuilder: ToastElementsMaker {
    
    private var config: ToastConfig
    
    public init(config: ToastConfig) {
        self.config = config
    }
    
    public func createIconImageView(icon: UIImage?) -> UIImageView {
        let view = UIImageView()
        view.tintColor = config.iconConfig.tintColor
        view.image = icon?.withRenderingMode(config.iconConfig.renderingMode)
        view.isHidden = icon == nil
        
        return view
    }
    
    public func createHeaderTextView(header: String?, delegate: UITextViewDelegate) -> UITextView {
        let textView = UITextView()
        textView.attributedText = header?.htmlConvertToAttributedString
        textView.font = config.textConfig.header.regularText.font
        textView.textColor = config.textConfig.header.regularText.color
        textView.backgroundColor = .clear
        textView.textAlignment = .left
        textView.textContainer.lineFragmentPadding = 0
        textView.textContainerInset = .zero
        
        textView.linkTextAttributes = [
            .font: config.textConfig.header.linkText.font,
            .foregroundColor: config.textConfig.header.linkText.color,
            .underlineStyle: 0
        ]
        textView.isEditable = false
        textView.isScrollEnabled = false
        textView.isUserInteractionEnabled = true
        textView.dataDetectorTypes = .link
        textView.delegate = delegate
        
        return textView
    }
    
    public func createMessageTextView(message: String?, delegate: UITextViewDelegate) -> UITextView {
        let textView = UITextView()
        textView.attributedText = message?.htmlConvertToAttributedString
        textView.font = config.textConfig.message.regularText.font
        textView.textColor = config.textConfig.message.regularText.color
        textView.backgroundColor = .clear
        textView.textAlignment = .left
        textView.textContainer.lineFragmentPadding = 0
        textView.textContainerInset = .zero
        
        textView.linkTextAttributes = [
            .font: config.textConfig.message.linkText.font,
            .foregroundColor: config.textConfig.message.linkText.color,
            .underlineStyle: 0
        ]
        textView.isEditable = false
        textView.isScrollEnabled = false
        textView.isUserInteractionEnabled = true
        textView.dataDetectorTypes = .link
        textView.delegate = delegate
        
        return textView
    }
}
