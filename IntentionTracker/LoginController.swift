//
//  ViewController.swift
//  IntentionTracker
//
//  Created by Dan Wiegand on 1/5/17.
//  Copyright © 2017 Stop It. All rights reserved.
//

import UIKit
import Firebase
import TextFieldEffects
import SimpleAlert

class LoginController: UIViewController {

    @IBOutlet weak var inputsView: UIView!
    
    @IBOutlet weak var emailTextField: KaedeTextField!
    @IBOutlet weak var passwordTextField: KaedeTextField!
    @IBOutlet weak var loginButtonView: UIView!
    @IBOutlet weak var loginButton: ZFRippleButton!
    
    public let backgroundColor = UIColor(colorLiteralRed: 245, green: 189, blue: 195, alpha: 1)
    
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setFormAttributes()
        changePlaceholderColors()
        self.hideKeyboardWhenTappedAround()
        
    
    }
    
    func changePlaceholderColors() {
       
        emailTextField.placeholderColor = UIColor.white
        passwordTextField.placeholderColor = UIColor.white
        
    }
    
    
    func setFormAttributes() {
        
        inputsView.layer.cornerRadius = 6
        inputsView.layer.masksToBounds = true
        inputsView.layer.borderColor = UIColor.white.cgColor
        inputsView.layer.borderWidth = 1
        
        loginButtonView.layer.cornerRadius = 6
        loginButtonView.layer.borderColor = UIColor.white.cgColor
        loginButtonView.layer.borderWidth = 1
        
        loginButton.layer.cornerRadius = 6
        
        
    }
    

    @IBAction func registerToggleButtonPressed(_ sender: UIButton) {
        
        performSegue(withIdentifier: "RegisterToggle", sender: nil)

    }
    
    @IBAction func loginButtonPressed(_ sender: UIButton) {
        
        FIRAuth.auth()?.signIn(withEmail: emailTextField.text!, password: passwordTextField.text!, completion: { (user, error) in
            if error != nil {
                print(error!)
                if let errCode = FIRAuthErrorCode(rawValue: error!._code) {
                    
                    switch errCode {
                    case .errorCodeInvalidEmail:
                        self.alertMessage(alertAction: AlertAction(title: "Email Invalid", style: .cancel) { action in
                        })
                    case .errorCodeInternalError:
                        self.alertMessage(alertAction: AlertAction(title: "Password Blank", style: .cancel) { action in
                        })
                    case .errorCodeUserNotFound:
                        self.alertMessage(alertAction: AlertAction(title: "User Not Found", style: .cancel) { action in
                        })
                    case .errorCodeWrongPassword:
                        self.alertMessage(alertAction: AlertAction(title: "Wrong Password", style: .cancel) { action in
                        })
                    case .errorCodeAccountExistsWithDifferentCredential:
                        self.alertMessage(alertAction: AlertAction(title: "User Not Found", style: .cancel) { action in
                        })
                    default:
                        print("Create User Error: \(error!)")
                        self.alertMessage(alertAction: AlertAction(title: "Error Logging In", style: .cancel) { action in
                        })
                    }
                }

                return
            }
        })
        
    }
    func alertMessage(alertAction: AlertAction) {
        let alert = AlertController(view: UIView(), style: .alert)
        let action = alertAction
        alert.addAction(action)
        action.button.frame.size.height = 300
        action.button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 26)
        action.button.setTitleColor(UIColor(netHex:0xF5BDC3), for: .normal)
        alert.configContainerWidth = {
            return 300
        }
        alert.configContainerCornerRadius = {
            return 150
        }
        alert.configContentView = { view in
            view?.backgroundColor = UIColor.white
            view?.alpha = 0.7
        }
        self.present(alert, animated: true, completion: nil)
    }

}

extension UIColor {
    convenience init(red: Int, green: Int, blue: Int) {
        assert(red >= 0 && red <= 255, "Invalid red component")
        assert(green >= 0 && green <= 255, "Invalid green component")
        assert(blue >= 0 && blue <= 255, "Invalid blue component")
        
        self.init(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: 1.0)
    }
    
    convenience init(netHex:Int) {
        self.init(red:(netHex >> 16) & 0xff, green:(netHex >> 8) & 0xff, blue:netHex & 0xff)
    }
}

extension UIViewController {
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
    }
    
    func dismissKeyboard() {
        view.endEditing(true)
    }
}

