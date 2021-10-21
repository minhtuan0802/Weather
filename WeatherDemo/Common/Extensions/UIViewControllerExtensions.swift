//
//  UIViewControllerExtensions.swift
//  BabyPhoto
//
//  Created by Thanh Vu on 7/17/20.
//  Copyright © 2020 Solar. All rights reserved.
//

import Foundation
import UIKit

extension UIViewController {
    func topVC() -> UIViewController {
        if let navigation = self as? UINavigationController, !navigation.viewControllers.isEmpty {
            return navigation.topViewController!.topVC()
        }
        
        if let presentedVC = self.presentedViewController {
            return presentedVC.topVC()
        }
        
        return self
    }
}
