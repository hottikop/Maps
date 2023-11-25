//
//  MapPoint.swift
//  Maps
//
//  Created by Максим Целигоров on 25.11.2023.
//

import UIKit

struct PinModel: Decodable {
    
    // MARK: - Properties
    
    var id: Int
    var coordinate: Coordinate
    var name: String
    var imageName: String
    var date: Date
}

extension PinModel {
    var image: UIImage? {
        UIImage(named: imageName)
    }
}
