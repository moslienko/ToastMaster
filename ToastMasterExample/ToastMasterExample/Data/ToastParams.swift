//
//  ToastParams.swift
//  ToastMasterExample
//
//  Created by Pavel Moslienko on 26.01.2024.
//

import Foundation

protocol ToastParamsSegment {
    static var id: Int { get }
    static var groupName: String { get }
    var fieldName: String { get }
}

enum ToastParams {
    
    enum TextContent: Int, CaseIterable, ToastParamsSegment {
        case onlyHeader = 0
        case onlyMsg = 1
        case both = 2
        
        static var id: Int = 101
        static var groupName: String = "Text Content"
        
        var fieldName: String {
            switch self {
            case .onlyHeader:
                return "Only header"
            case .onlyMsg:
                return "Only message"
            case .both:
                return "Display both"
            }
        }
    }
    
    enum IconOptions: Int, CaseIterable, ToastParamsSegment {
        case regularIcon = 0
        case colorIcon = 1
        case withoutIcon = 2
        
        static var id: Int = 102
        static var groupName: String = "Icon Options"
        
        var fieldName: String {
            switch self {
            case .regularIcon:
                return "Regular icon"
            case .colorIcon:
                return "Color icon"
            case .withoutIcon:
                return "Without icon"
            }
        }
    }
    
    enum ToastLayout: Int, CaseIterable, ToastParamsSegment {
        case horizontal = 0
        case vertical = 1
        
        static var id: Int = 103
        static var groupName: String = "Toast layout"
        
        var fieldName: String {
            switch self {
            case .horizontal:
                return "Horizontal"
            case .vertical:
                return "Vertical"
            }
        }
    }
    
    enum ButtonOptions: Int, CaseIterable, ToastParamsSegment {
        case onlyLink = 0
        case onlyAction = 1
        case both = 2
        
        static var id: Int = 104
        static var groupName: String = "Action Button"
        
        var fieldName: String {
            switch self {
            case .onlyLink:
                return "Only as link"
            case .onlyAction:
                return "Only as action"
            case .both:
                return "Display both"
            }
        }
    }
}
