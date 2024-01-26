//
//  String+Ext.swift
//  
//
//  Created by Pavel Moslienko on 24.01.2024.
//

import Foundation

extension String {
    
    var htmlConvertToAttributedString: NSAttributedString? {
        guard let data = data(using: .utf8) else { return nil }
        do {
            return try NSAttributedString(data: data, options: [.documentType: NSAttributedString.DocumentType.html, .characterEncoding:String.Encoding.utf8.rawValue], documentAttributes: nil)
        } catch {
            return nil
        }
    }
}
