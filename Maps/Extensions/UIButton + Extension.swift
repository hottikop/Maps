//
//  UIButton + Extension.swift
//  Maps
//
//  Created by Максим Целигоров on 25.11.2023.
//

import UIKit

extension UIButton {
    func addTargetTouch(_ target: Any?, action: Selector) {
        self.addTarget(target, action: action, for: .touchUpInside)
    }
}
