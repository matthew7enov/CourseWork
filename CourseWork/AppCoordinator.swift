//
//  AppCoordinator.swift
//  CourseWork
//
//  Created by Matvei Semenov on 11/12/2022.
//

import UIKit

class AppCoordinator {
    var window: UIWindow?

    static var shared = AppCoordinator()

    lazy var userService = UserService.shared

    func start() {
        if userService.isUserSignedIn {
            let tabBarVC = UIStoryboard.main.instantiateViewController(withIdentifier: TabBarController.storyboardId) as? TabBarController ?? UIViewController()
            window?.rootViewController = tabBarVC
        } else {
            let loginVC = UIStoryboard.main.instantiateViewController(withIdentifier: LoginViewController.storyboardId) as? LoginViewController ?? UIViewController()
            let navVC = UINavigationController(rootViewController: loginVC)
            window?.rootViewController = navVC
        }
    }

    func didLogin() {
        let tabBarVC = UIStoryboard.main.instantiateViewController(withIdentifier: TabBarController.storyboardId) as? TabBarController ?? UIViewController()
        window?.rootViewController = tabBarVC
    }

    func logout() {
        userService.logout()
        
        let loginVC = UIStoryboard.main.instantiateViewController(withIdentifier: LoginViewController.storyboardId) as? LoginViewController ?? UIViewController()
        let navVC = UINavigationController(rootViewController: loginVC)
        window?.rootViewController = navVC
    }
}
