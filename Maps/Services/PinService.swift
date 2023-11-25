//
//  PinService.swift
//  Maps
//
//  Created by Максим Целигоров on 25.11.2023.
//

import Foundation

protocol PinServiceProtocol {
    func getPins(_ completion: @escaping ([PinModel]) -> Void)
}

final class PinService: PinServiceProtocol {
    func getPins(_ completion: @escaping ([PinModel]) -> Void) {
        DispatchQueue.global().async {
            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            decoder.dateDecodingStrategy = .secondsSince1970
            guard
                let fileUrl = Bundle.main.url(forResource: Constants.pinPath, withExtension: "json"),
                let data = try? Data(contentsOf: fileUrl),
                let pinModels = try? decoder.decode(PinModels.self, from: data)
            else {
                return
            }
            DispatchQueue.main.async {
                completion(pinModels.pins)
            }
        }
    }
}
