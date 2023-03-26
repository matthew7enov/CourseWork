//
//  RegistrationViewController.swift
//  CourseWork
//
//  Created by Matvei Semenov on 11/12/2022.
//

import UIKit
import SVProgressHUD

class RegistrationController: UIViewController {
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!

    let userService = UserService.shared

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    @IBAction func didPressLoginButton(_ sender: Any) {
        guard let email = emailTextField.text,
              let password = passwordTextField.text else {
            return
        }
        SVProgressHUD.show()
        userService.signUp(with: email, password: password) { success in
            SVProgressHUD.dismiss()
            if success {
                AppCoordinator.shared.didLogin()
            } else {
                SVProgressHUD.showError(withStatus: "Something went wrong")
            }
        }
    }

}
