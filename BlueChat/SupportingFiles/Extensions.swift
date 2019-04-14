//
//  Extensions.swift
//  BlueChat
//
//  Created by Josip Rezic on 11/04/2019.
//  Copyright © 2019 Josip Rezic. All rights reserved.
//

import Foundation
import UIKit

extension UIViewController {
    public class func fromStoryboard() -> Self {
        func fromStoryboardHelper<T>() -> T where T : UIViewController {
            let storyboard = UIStoryboard(name: String(describing: T.self), bundle: nil)
            return storyboard.instantiateInitialViewController() as! T
        }
        return fromStoryboardHelper()
    }
}
