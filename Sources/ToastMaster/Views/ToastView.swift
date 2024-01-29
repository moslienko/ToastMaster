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
    
    // MARK: - Params
    public var config = ToastConfig()
    private var presentationService: ToastPresentationService {
        ToastPresentationService(container: toastContainer, config: config)
    }
    
    // MARK: - Callbacks
    public var buttonTapped: (() -> Void)?
    public var linkTapped: ((String) -> Void)?
    
    // MARK: - UI components
    private(set) lazy var toastContainer: UIView = {
        let view = UIView()
        view.clipsToBounds = true
        view.alpha = 0.0
        
        return view
    }()
    
    private(set) lazy var contentStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 0.0
        stackView.alignment = .center //l
        stackView.distribution = .fill
        
        return stackView
    }()
    
    private(set) lazy var textStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 0.0
        stackView.alignment = .leading
        stackView.distribution = .fill
        
        return stackView
    }()
    
    private(set) lazy var actionButton: UIButton = {
        let button = UIButton()
        button.setTitleColor(config.buttonConfig.color, for: [])
        button.titleLabel?.font = config.buttonConfig.font
        button.titleLabel?.textAlignment = .left
        button.contentHorizontalAlignment = .left
        button.contentVerticalAlignment = .center
        button.addTarget(self, action: #selector(self.actionButtonTapped(_:)), for: .touchUpInside)
        
        return button
    }()
    
    public func show(header: String?, message: String?, icon: UIImage?, actionButtonTitle: String?, controller: UIViewController, buttonTapped: (() -> Void)?, linkTapped: ((String) -> Void)?) {        
        self.presentationService.dissmiss(withAnimation: false)

        self.buttonTapped = buttonTapped
        self.linkTapped = linkTapped

        switch config.layout {
        case .horizontal:
            self.contentStackView.axis = .horizontal
        case .vertical:
            self.contentStackView.axis = .vertical
        }
        
        self.toastContainer.backgroundColor = config.containerConfig.backgroundColor
        self.toastContainer.layer.cornerRadius = config.containerConfig.cornerRadius
        
        self.actionButton.setTitle(actionButtonTitle, for: [])
        self.actionButton.isHidden = actionButtonTitle == nil
        
        let iconImageView: UIImageView = {
            let view = UIImageView()
            view.tintColor = config.iconConfig.tintColor
            view.image = icon?.withRenderingMode(config.iconConfig.renderingMode)
            view.isHidden = icon == nil
            
            return view
        }()
        
        self.toastContainer.subviews.forEach({ $0.removeFromSuperview() })
        self.contentStackView.arrangedSubviews.forEach({ $0.removeFromSuperview() })
        self.textStackView.arrangedSubviews.forEach({ $0.removeFromSuperview() })
        
        if self.config.containerConfig.isNeedBlur {
            let blurEffect = UIBlurEffect(style: self.config.containerConfig.blurStyle ?? .dark)
            let blurView = UIVisualEffectView(effect: blurEffect)
            blurView.frame = self.toastContainer.bounds
            blurView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
            blurView.layer.opacity = 0.75
            self.toastContainer.addSubview(blurView)
        }
        
        let headerTextView: UITextView = {
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
            textView.delegate = self
            
            return textView
        }()
        
        let messageTextView: UITextView = {
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
            textView.delegate = self
            
            return textView
        }()
        
        self.textStackView.addArrangedSubview(headerTextView)
        headerTextView.isHidden = header == nil
        
        self.textStackView.addArrangedSubview(messageTextView)
        messageTextView.isHidden = message == nil
        iconImageView.isHidden = icon == nil
        
        contentStackView.alignment = config.layout == .vertical ? .leading : .center
        
        self.contentStackView.addArrangedSubview(self.textStackView)
        self.contentStackView.addArrangedSubview(actionButton)
        
        toastContainer.addSubview(iconImageView)
        toastContainer.addSubview(self.contentStackView)
        controller.view.addSubview(toastContainer)
        
        toastContainer.translatesAutoresizingMaskIntoConstraints = false
        iconImageView.translatesAutoresizingMaskIntoConstraints = false
        self.contentStackView.translatesAutoresizingMaskIntoConstraints = false
        
        var positionConstraint: NSLayoutConstraint {
            switch self.config.displayConfig.position {
            case .top:
                return toastContainer.topAnchor.constraint(equalTo: controller.view.safeAreaLayoutGuide.topAnchor, constant: self.config.containerConfig.insets.top)
            case .bottom:
                return toastContainer.bottomAnchor.constraint(equalTo: controller.view.safeAreaLayoutGuide.bottomAnchor, constant: self.config.containerConfig.insets.bottom)
            }
        }
        
        NSLayoutConstraint.activate([
            toastContainer.leadingAnchor.constraint(equalTo: controller.view.safeAreaLayoutGuide.leadingAnchor, constant: self.config.containerConfig.insets.left),
            toastContainer.trailingAnchor.constraint(equalTo: controller.view.safeAreaLayoutGuide.trailingAnchor, constant: self.config.containerConfig.insets.right),
            positionConstraint,
            
            iconImageView.leadingAnchor.constraint(equalTo: toastContainer.leadingAnchor, constant: 16),
            iconImageView.centerYAnchor.constraint(equalTo: toastContainer.centerYAnchor),
            iconImageView.widthAnchor.constraint(equalToConstant: icon != nil ? config.iconConfig.size.width : 0),
            iconImageView.heightAnchor.constraint(equalToConstant: icon != nil ? config.iconConfig.size.height : 0),
            
            self.contentStackView.topAnchor.constraint(greaterThanOrEqualTo: toastContainer.topAnchor, constant: 9),
            self.contentStackView.bottomAnchor.constraint(greaterThanOrEqualTo: toastContainer.bottomAnchor, constant: -9),
            self.contentStackView.centerYAnchor.constraint(equalTo: toastContainer.centerYAnchor),
            self.contentStackView.trailingAnchor.constraint(equalTo: toastContainer.trailingAnchor, constant: -16),
            self.contentStackView.leadingAnchor.constraint(equalTo: toastContainer.leadingAnchor, constant:  icon != nil ? 54 : 16)
        ])
        
        if let dismissGesture = self.toastContainer.gestureRecognizers?.first(where: { $0 is UISwipeGestureRecognizer }) as? UISwipeGestureRecognizer {
            self.toastContainer.removeGestureRecognizer(dismissGesture)
        }
        
        let dismissGesture = UISwipeGestureRecognizer(target: self, action: #selector(dismissView(gesture:)))
        switch self.config.displayConfig.position {
        case .top:
            dismissGesture.direction = .up
        case .bottom:
            dismissGesture.direction = .down
        }
        dismissGesture.delegate = self
        dismissGesture.cancelsTouchesInView = false
        
        self.toastContainer.addGestureRecognizer(dismissGesture)
        self.toastContainer.isUserInteractionEnabled = true
        
        self.presentationService.present()
    }
}

// MARK: - Actions
private extension ToastView {
    
    @objc
    func dismissView(gesture: UISwipeGestureRecognizer) {
        self.presentationService.dissmiss(withAnimation: true)
    }
    
    @objc
    func actionButtonTapped(_ sender: UIButton) {
        self.buttonTapped?()
        self.presentationService.dissmiss(withAnimation: true)
    }
}

// MARK: - UITextViewDelegate
extension ToastView: UITextViewDelegate {
    
    public func textView(_ textView: UITextView, shouldInteractWith URL: URL, in characterRange: NSRange, interaction: UITextItemInteraction) -> Bool {
        self.linkTapped?(URL.relativeString)
        self.presentationService.dissmiss(withAnimation: true)
        return false
    }
}

// MARK: - UIGestureRecognizerDelegate
extension ToastView: UIGestureRecognizerDelegate {
    
    public func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        true
    }
}
