//
//  SceneDelegate.swift
//  SoongBook
//
//  Created by 이숭인 on 11/4/24.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?


    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        
        window = UIWindow(windowScene: windowScene)
        let mainViewController = MainViewController()
//        mainViewController.view.backgroundColor = .systemCyan
        
        window?.rootViewController = mainViewController
        window?.makeKeyAndVisible()
    }
}

