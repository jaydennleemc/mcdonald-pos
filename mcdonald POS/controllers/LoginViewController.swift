//
//  ViewController.swift
//  macdonald_pos
//
//  Created by Jayden on 29/1/2022.
//

import UIKit
import Toast

class LoginViewController: UIViewController {
        
    @IBOutlet weak var username: UITextField!
    @IBOutlet weak var password: UITextField!
    
    let sqlManager = SQLManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
    }

    @IBAction func loginOnClick(_ sender: Any) {
        guard let usernameText = username.text, !usernameText.isEmpty else {
            self.view.makeToast("Username could not empty")
            return
        }
        
        guard let passwordText = password.text, !passwordText.isEmpty else {
            self.view.makeToast("Password could not empty")
            return
        }

        do {
            if let user = try sqlManager.loginUser(username: usernameText, password: passwordText.md5Value) {
                if (user.username == usernameText) {
                    let vc = self.storyboard?.instantiateViewController(withIdentifier: "HomeViewController") as? HomeViewController
                    vc?.modalPresentationStyle = .fullScreen
                    self.present(vc!, animated: true, completion: nil)
                }
            }else {
                self.view.makeToast("Username or password incorrect !")
            }
        }catch {
            self.view.makeToast("Internal error")
            debugPrint("login error")
        }
    }
    
}

