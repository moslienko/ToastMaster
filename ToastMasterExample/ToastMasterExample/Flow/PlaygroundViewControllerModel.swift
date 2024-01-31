//
//  PlaygroundViewController.swift
//  ToastMasterExample
//
//  Created by Pavel Moslienko on 27.01.2024.
//

import Foundation
import ToastMaster
import UIKit

class PlaygroundViewControllerModel {
    
    var toastConfig = ToastConfig()
    
    var toastHeader: String?
    var toastMessage: String?
    var toastActionButtonTitle: String?
    var toastIcon: UIImage?
    var textOptions: ToastParams.TextContent = .both {
        didSet {
            switch textOptions {
            case .onlyHeader:
                self.toastMessage = nil
            case .onlyMsg:
                self.toastHeader = nil
            case .both:
                break
            }
        }
    }
    var isShowLinks = false {
        didSet {
            self.toastHeader = isShowLinks ? "Header with <a href=\"http://linkOne\">link</a>" : "Lorem Ipsum"
            self.toastMessage = isShowLinks ? "Message with <a href=\"http://linkTwo\">link</a>" : "Lorem ipsum dolor sit amet"
            
            switch self.textOptions {
            case .onlyHeader:
                self.toastMessage = nil
            case .onlyMsg:
                self.toastHeader = nil
            case .both:
                break
            }
        }
    }
}
