//
//  ToastView.swift
//  
//
//  Created by Pavel Moslienko on 24.01.2024.
//

import UIKit

public protocol ToastProtocol {
    var config: ToastConfig { get set }
    var buttonTapped: (() -> Void)? { get set }
    var linkTapped: ((String) -> Void)? { get set }
    
    func show(header: String?, message: String?, icon: UIImage?, actionButtonTitle: String?, controller: UIViewController, buttonTapped: (() -> Void)?, linkTapped: ((String) -> Void)?)
}

public class ToastView: NSObject, ToastProtocol {
    
    public static let shared = ToastView()
    
    private override init() {}
    
    // MARK: - Params
    public var config = ToastConfig()
    public var dismissWorkItem: DispatchWorkItem?
    
    private var presentationService: ToastPresentationService {
        let service = ToastPresentationService(container: toastContainer, config: config)
        service.didToastPresented = { [weak self] in
            self?.setupAutoDismissToast()
        }
        
        return service
    }
    private var elementsBuilder: ToastElementsMaker {
        ToastElementsBuilder(config: config)
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
        stackView.alignment = .center
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
    
    /// Show toast view
    /// - Parameters:
    ///   - header: Toast title, displayed first
    ///   - message: Toast message, displayed second
    ///   - icon: Icon, displayd in left part of toast
    ///   - actionButtonTitle: Button text, if the button is not needed, do not pass the argument
    ///   - controller: Parent view controller
    ///   - buttonTapped: Handle button tap event
    ///   - linkTapped: Handle link tap event
    public func show(header: String?, message: String?, icon: UIImage?, actionButtonTitle: String?, controller: UIViewController, buttonTapped: (() -> Void)?, linkTapped: ((String) -> Void)?) {
        self.presentationService.dissmiss(withAnimation: false)
        
        self.buttonTapped = buttonTapped
        self.linkTapped = linkTapped
        
        self.toastContainer.backgroundColor = config.containerConfig.backgroundColor
        self.toastContainer.layer.cornerRadius = config.containerConfig.cornerRadius
        
        self.actionButton.setTitle(actionButtonTitle, for: [])
        self.actionButton.isHidden = actionButtonTitle == nil
        
        self.setupBlurIfNeeded()
        
        let iconImageView = self.elementsBuilder.createIconImageView(icon: icon)
        let headerTextView = self.elementsBuilder.createHeaderTextView(header: header, delegate: self)
        let messageTextView = self.elementsBuilder.createMessageTextView(message: message, delegate: self)
        
        setupConstraints(headerTextView, header, messageTextView, message, iconImageView, icon, controller)
        self.setupGesture()
        
        self.presentationService.present()
    }
}

// MARK: - Setup
private extension ToastView {
    
    func setupGesture() {
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
    }
    
    func setupConstraints(_ headerTextView: UITextView, _ header: String?, _ messageTextView: UITextView, _ message: String?, _ iconImageView: UIImageView, _ icon: UIImage?, _ controller: UIViewController) {
        switch config.layout {
        case .horizontal:
            self.contentStackView.axis = .horizontal
        case .vertical:
            self.contentStackView.axis = .vertical
        }
        
        
        self.toastContainer.subviews.forEach({ $0.removeFromSuperview() })
        self.contentStackView.arrangedSubviews.forEach({ $0.removeFromSuperview() })
        self.textStackView.arrangedSubviews.forEach({ $0.removeFromSuperview() })
        
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
        
        var contentLeftConstraint: NSLayoutConstraint {
            if icon != nil {
                return self.contentStackView.leadingAnchor.constraint(equalTo: iconImageView.trailingAnchor, constant: 13)
            }
            return self.contentStackView.leadingAnchor.constraint(equalTo: toastContainer.leadingAnchor, constant: 16)
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
           contentLeftConstraint
        ])
    }
    
    func setupBlurIfNeeded() {
        guard self.config.containerConfig.isNeedBlur else {
            return
        }
        let blurEffect = UIBlurEffect(style: self.config.containerConfig.blurStyle ?? .dark)
        let blurView = UIVisualEffectView(effect: blurEffect)
        blurView.frame = self.toastContainer.bounds
        blurView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        blurView.layer.opacity = 0.75
        self.toastContainer.addSubview(blurView)
    }
    
   func setupAutoDismissToast() {
        let workItem = DispatchWorkItem { [weak self] in
            self?.presentationService.dissmiss(withAnimation: true)
        }
        ToastView.shared.dismissWorkItem = workItem
        
        DispatchQueue.main.asyncAfter(deadline: .now() + self.config.displayConfig.toastDuration, execute: workItem)
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
