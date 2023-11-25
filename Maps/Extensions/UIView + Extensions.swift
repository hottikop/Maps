//
//  UIView + Extensions.swift
//  Maps
//
//  Created by Максим Целигоров on 25.11.2023.
//

import UIKit

extension UIView {
    func addSubviews(_ views: UIView...) {
        views.forEach { addSubview($0) }
    }
}
