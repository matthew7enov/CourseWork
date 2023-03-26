//
//  UserAccountViewController.swift
//  CourseWork
//
//  Created by Matvei Semenov on 11/12/2022.
//

import UIKit

class UserAccountController: UIViewController {
    let userService = UserService.shared

    @IBOutlet weak var emailLabel: UILabel!
    var user: User? {
        userService.currentUser
    }


    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        updateUI()
    }

    private func updateUI() {
        guard let user = user else { return }
        emailLabel.text = user.email
    }

    @IBAction func didPressLogout(_ sender: Any) {
        AppCoordinator.shared.logout()
    }

}
