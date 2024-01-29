//
//  PlaygroundViewController.swift
//  ToastMasterExample
//
//  Created by Pavel Moslienko on 01.01.2024.
//

import UIKit
import ToastMaster

class PlaygroundViewController: UIViewController {
    
    var viewModel = PlaygroundViewControllerModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupView()
    }
}

// MARK: - Module methods
private extension PlaygroundViewController {
    
    func setupView() {
        self.viewModel.toastConfig.containerConfig.insets = UIEdgeInsets(top: 0.0, left: 16.0, bottom: -70.0, right: -16.0)
        
        self.viewModel.isShowLinks = false
        self.viewModel.toastActionButtonTitle = "Open"
        self.viewModel.toastIcon = UIImage(systemName: "info.circle.fill")
        
        let scrollView = UIScrollView()
        
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 12.0
        stackView.alignment = .leading
        stackView.distribution = .fill
        
        let bigButton = UIButton()
        bigButton.setTitle("Show toast", for: .normal)
        bigButton.titleLabel?.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        bigButton.titleLabel?.textColor = .white
        bigButton.backgroundColor = .systemBlue
        bigButton.layer.cornerRadius = 15.0
        bigButton.addTarget(self, action: #selector(bigButtonTapped), for: .touchUpInside)
        
        stackView.addArrangedSubview(self.label(text: ToastParams.TextContent.groupName))
        stackView.addArrangedSubview(self.segment(items: ToastParams.TextContent.allCases.map({ $0.fieldName }), selectedIndex: self.viewModel.textOptions.rawValue, id: ToastParams.TextContent.id))
        
        stackView.addArrangedSubview(self.label(text: ToastParams.IconOptions.groupName))
        stackView.addArrangedSubview(self.segment(items: ToastParams.IconOptions.allCases.map({ $0.fieldName }), selectedIndex: 0, id: ToastParams.IconOptions.id))
        
        stackView.addArrangedSubview(self.label(text: ToastParams.ToastLayout.groupName))
        stackView.addArrangedSubview(self.segment(items: ToastParams.ToastLayout.allCases.map({ $0.fieldName }), selectedIndex: 1, id: ToastParams.ToastLayout.id))
        
        stackView.addArrangedSubview(self.label(text: ToastParams.ToastPosition.groupName))
        stackView.addArrangedSubview(self.segment(items: ToastParams.ToastPosition.allCases.map({ $0.fieldName }), selectedIndex: 1, id: ToastParams.ToastPosition.id))
        
        stackView.addArrangedSubview(self.label(text: ToastParams.ButtonOptions.groupName))
        stackView.addArrangedSubview(self.segment(items: ToastParams.ButtonOptions.allCases.map({ $0.fieldName }), selectedIndex: 1, id: ToastParams.ButtonOptions.id))
        
        stackView.addArrangedSubview(self.label(text: ToastParams.ContainerOptions.groupName))
        stackView.addArrangedSubview(self.segment(items: ToastParams.ContainerOptions.allCases.map({ $0.fieldName }), selectedIndex: 0, id: ToastParams.ContainerOptions.id))
        
        scrollView.addSubview(stackView)
        view.addSubview(scrollView)
        view.addSubview(bigButton)
        
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        stackView.translatesAutoresizingMaskIntoConstraints = false
        bigButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: bigButton.topAnchor),
            
            stackView.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 16),
            stackView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 16),
            stackView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: -16),
            
            bigButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            bigButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            bigButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            bigButton.heightAnchor.constraint(equalToConstant: 60)
        ])
    }
}

// MARK: - Components builder
private extension PlaygroundViewController {
    
    func label(text: String) -> UILabel {
        let label = UILabel()
        label.text = text
        label.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        label.textColor = .black
        label.textAlignment = .left
        label.numberOfLines = 0
        
        return label
    }
    
    func segment(items: [String], selectedIndex: Int, id: Int) -> UISegmentedControl {
        let segmentedControl = UISegmentedControl(items: items)
        segmentedControl.selectedSegmentIndex = selectedIndex
        segmentedControl.tag = id
        segmentedControl.addTarget(self, action: #selector(segmentedControlValueChanged), for: .valueChanged)
        
        return segmentedControl
    }
}

// MARK: - Actions
private extension PlaygroundViewController {
    
    @objc
    func segmentedControlValueChanged(_ sender: UISegmentedControl) {
        switch sender.tag {
        case ToastParams.TextContent.id:
            guard let val = ToastParams.TextContent(rawValue: sender.selectedSegmentIndex) else {
                return
            }
            self.viewModel.textOptions = val
            self.viewModel.isShowLinks.toggle()
            self.viewModel.isShowLinks.toggle()
        case ToastParams.IconOptions.id:
            guard let val = ToastParams.IconOptions(rawValue: sender.selectedSegmentIndex) else {
                return
            }
            self.viewModel.toastIcon = UIImage(systemName: "info.circle.fill")
            
            switch val {
            case .regularIcon:
                self.viewModel.toastConfig.iconConfig.tintColor = .white
            case .colorIcon:
                self.viewModel.toastConfig.iconConfig.tintColor = .blue
            case .withoutIcon:
                self.viewModel.toastIcon = nil
            }
        case ToastParams.ToastLayout.id:
            guard let val = ToastParams.ToastLayout(rawValue: sender.selectedSegmentIndex) else {
                return
            }
            switch val {
            case .horizontal:
                self.viewModel.toastConfig.layout = .horizontal
            case .vertical:
                self.viewModel.toastConfig.layout = .vertical
            }
        case ToastParams.ToastPosition.id:
            guard let val = ToastParams.ToastPosition(rawValue: sender.selectedSegmentIndex) else {
                return
            }
            switch val {
            case .top:
                self.viewModel.toastConfig.displayConfig.position = .top
            case .bottom:
                self.viewModel.toastConfig.displayConfig.position = .bottom
            }
        case ToastParams.ButtonOptions.id:
            guard let val = ToastParams.ButtonOptions(rawValue: sender.selectedSegmentIndex) else {
                return
            }
            self.viewModel.toastActionButtonTitle = "Open"
            
            switch val {
            case .onlyLink:
                self.viewModel.isShowLinks = true
                self.viewModel.toastActionButtonTitle = nil
            case .onlyAction:
                self.viewModel.isShowLinks = false
            case .both:
                self.viewModel.isShowLinks = true
            }
        case ToastParams.ContainerOptions.id:
            guard let val = ToastParams.ContainerOptions(rawValue: sender.selectedSegmentIndex) else {
                return
            }
            switch val {
            case .default:
                self.viewModel.toastConfig.containerConfig = ContainerConfig()
            case .withBlur:
                self.viewModel.toastConfig.containerConfig = ContainerConfig()
                self.viewModel.toastConfig.containerConfig.backgroundColor = .black.withAlphaComponent(0.5)
                self.viewModel.toastConfig.containerConfig.isNeedBlur = true
                self.viewModel.toastConfig.containerConfig.blurStyle = .dark
            case .colorBackground:
                self.viewModel.toastConfig.containerConfig = ContainerConfig()
                self.viewModel.toastConfig.containerConfig.backgroundColor = .systemRed
                self.viewModel.toastConfig.containerConfig.cornerRadius = 4.0
            }
        default:
            break
        }
    }
    
    @objc
    func bigButtonTapped() {
        ToastView.shared.config = self.viewModel.toastConfig
        
        ToastView.shared.show(
            header: self.viewModel.toastHeader,
            message: self.viewModel.toastMessage,
            icon: self.viewModel.toastIcon,
            actionButtonTitle: self.viewModel.toastActionButtonTitle,
            controller: self,
            buttonTapped: {
                print("button tap")
            },
            linkTapped: { link in
                print("tapped - \(link)")
            }
        )
    }
}
