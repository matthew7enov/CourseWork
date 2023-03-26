//
//  LoginViewController.swift
//  CourseWork
//
//  Created by Matvei Semenov on 5.12.22.
//

import UIKit
import AVFoundation
import SVProgressHUD

class LoginViewController: UIViewController {
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
        userService.signIn(with: email, password: password) { success in
            SVProgressHUD.dismiss()
            if success {
                AppCoordinator.shared.didLogin()
            } else {
                SVProgressHUD.showError(withStatus: "Something went wrong")
            }
        }
    }

}





    

    
    




