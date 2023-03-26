//
//  UIUtils.swift
//  CourseWork
//
//  Created by Matvei Semenov on 11/12/2022.
//

import UIKit

extension UIStoryboard {
    static var main: UIStoryboard = {
        return .init(name: "Main", bundle: .main)
    }()
}

extension UIViewController {
    static var storyboardId: String {
        return String(describing: self)
    }
}
