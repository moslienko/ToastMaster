//
//  ToastView.swift
//  
//
//  Created by Pavel Moslienko on 24.01.2024.
//

import UIKit

public class ToastView: NSObject {
    
    public static let shared = ToastView()
    
    private override init() {}
    
    private var dismissWorkItem: DispatchWorkItem?
    
    var config = ToastConfig()
    var linkTapped: ((String) -> Void)?
    
    private(set) lazy var toastContainer: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(red: 0.175, green: 0.175, blue: 0.175, alpha: 0.8)
        view.layer.cornerRadius = 16.0
        view.clipsToBounds = true
        view.alpha = 0.0
        
        return view
    }()
    
    public func show(message: String, controller: UIViewController, icon: UIImage?, linkTapped: ((String) -> Void)?) {
        self.dissmissToast(withAnimation: false)
        self.linkTapped = linkTapped
        
        let iconImageView: UIImageView = {
            let view = UIImageView()
            view.tintColor = config.iconConfig.tintColor
            return view
        }()
        
        let messageTextView: UITextView = {
            let textView = UITextView()
            textView.attributedText = message.htmlConvertToAttributedString
            textView.font = config.textConfig.message.regularText.font
            textView.textColor = config.textConfig.message.regularText.color
            textView.backgroundColor = .clear
            
            textView.linkTextAttributes = [
                .font: config.textConfig.message.linkText.font,
                .foregroundColor: config.textConfig.message.linkText.color,
                .underlineStyle: 0
            ]
            textView.isEditable = false
            textView.isScrollEnabled = false
            textView.isUserInteractionEnabled = true
            textView.dataDetectorTypes = .link
            textView.delegate = self
            
            return textView
        }()
        
        toastContainer.addSubview(iconImageView)
        toastContainer.addSubview(messageTextView)
        controller.view.addSubview(toastContainer)
        
        toastContainer.translatesAutoresizingMaskIntoConstraints = false
        iconImageView.translatesAutoresizingMaskIntoConstraints = false
        messageTextView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            toastContainer.leadingAnchor.constraint(equalTo: controller.view.leadingAnchor, constant: 16),
            toastContainer.trailingAnchor.constraint(equalTo: controller.view.trailingAnchor, constant: -16),
            toastContainer.bottomAnchor.constraint(equalTo: controller.view.bottomAnchor, constant: -99),
            
            iconImageView.leadingAnchor.constraint(equalTo: toastContainer.leadingAnchor, constant: 16),
            iconImageView.centerYAnchor.constraint(equalTo: toastContainer.centerYAnchor),
            iconImageView.widthAnchor.constraint(equalToConstant: 28),
            iconImageView.heightAnchor.constraint(equalToConstant: 28),
            
            messageTextView.topAnchor.constraint(equalTo: toastContainer.topAnchor, constant: 10),
            messageTextView.bottomAnchor.constraint(equalTo: toastContainer.bottomAnchor, constant: -10),
            messageTextView.trailingAnchor.constraint(equalTo: toastContainer.trailingAnchor, constant: -16),
            messageTextView.leadingAnchor.constraint(equalTo: toastContainer.leadingAnchor, constant: 56)
        ])
        
        iconImageView.image = icon?.withRenderingMode(config.iconConfig.renderingMode)
        
        let slideDown = UISwipeGestureRecognizer(target: self, action: #selector(dismissView(gesture:)))
        slideDown.direction = .down
        self.toastContainer.addGestureRecognizer(slideDown)
        self.toastContainer.isUserInteractionEnabled = true
        
        self.presentToast()
    }
    
    @objc
    private func dismissView(gesture: UISwipeGestureRecognizer) {
        self.dissmissToast(withAnimation: true)
    }
    
    private func presentToast() {
        UIView.animate(
            withDuration: 0.5,
            delay: 0.0,
            options: .curveEaseIn,
            animations: {
                self.toastContainer.alpha = 1.0
            }, completion: { _ in
                let workItem = DispatchWorkItem { [weak self] in
                    self?.dissmissToast(withAnimation: true, isAutoDismiss: true)
                }
                self.dismissWorkItem = workItem
                DispatchQueue.main.asyncAfter(deadline: .now() + 3.5, execute: workItem)
            }
        )
    }
    
    private func dissmissToast(withAnimation: Bool, isAutoDismiss: Bool = false) {
        if withAnimation {
            UIView.animate(
                withDuration: 0.5,
                delay: 0.0,
                options: .curveEaseOut,
                animations: {
                    self.toastContainer.alpha = 0.0
                }, completion: { _ in
                    self.toastContainer.removeFromSuperview()
                }
            )
        } else {
            self.toastContainer.removeFromSuperview()
        }
        
        if isAutoDismiss {
            dismissWorkItem?.cancel()
        }
    }
}

extension ToastView: UITextViewDelegate {
    
    public func textView(_ textView: UITextView, shouldInteractWith URL: URL, in characterRange: NSRange, interaction: UITextItemInteraction) -> Bool {
        self.linkTapped?(URL.absoluteString)
        self.dissmissToast(withAnimation: true)
        return false
    }
}
