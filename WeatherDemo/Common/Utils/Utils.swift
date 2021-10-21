//
//  Utils.swift
//  dmv
//
//  Created by ngo van do on 02/06/2021.
//

import Foundation
import UIKit
//typealias CompletionBlock = (() -> Void)?

struct DateFormat {
    static let longFormat = "MM-dd-yyyy HH:mm:ss"
    static let shortFormat = "MM-dd-yyyy"
}


class Utils {
    
    static let pdfSize = CGSize.init(width: 595.2, height: 841.8)
    
    static func stringFromDate(_ date: Date, format: String) -> String? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        return dateFormatter.string(from: date)
    }
    
    static func dateFromString(_ string: String, format: String) -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        return dateFormatter.date(from: string)
    }
}


func openSetting() {
    if let url = URL.init(string: UIApplication.openSettingsURLString) {
        if UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
    }
}
