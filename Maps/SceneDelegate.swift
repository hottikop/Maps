//
//  SceneDelegate.swift
//  Maps
//
//  Created by Максим Целигоров on 24.11.2023.
//

import UIKit
import YandexMapsMobile

final class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {

        guard let windowScene = (scene as? UIWindowScene) else { return }
        window = UIWindow(windowScene: windowScene)
        
        YMKMapKit.setApiKey(Constants.apiKey)
        YMKMapKit.sharedInstance()
        
        window?.rootViewController = MapViewController()
        window?.makeKeyAndVisible()
    }
}

