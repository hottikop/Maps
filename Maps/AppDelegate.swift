//
//  AppDelegate.swift
//  Maps
//
//  Created by Максим Целигоров on 24.11.2023.
//

import UIKit
import YandexMapsMobile

@main
final class AppDelegate: UIResponder, UIApplicationDelegate {
    
    // MARK: - UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }
}

