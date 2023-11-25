//
//  Coordinate.swift
//  Maps
//
//  Created by Максим Целигоров on 25.11.2023.
//

import Foundation
import YandexMapsMobile

struct Coordinate: Decodable {
    var latitude: Double = 0
    var longitude: Double = 0
}

extension Coordinate {
    var ymkPoint: YMKPoint {
        YMKPoint(latitude: latitude, longitude: longitude)
    }
}
