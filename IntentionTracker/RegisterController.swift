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


class RegisterController: UIViewController {
    
    @IBOutlet weak var inputsView: UIView!
    
    @IBOutlet weak var nameTextField: KaedeTextField!
    @IBOutlet weak var emailTextField: KaedeTextField!
    @IBOutlet weak var passwordTextField: KaedeTextField!
    @IBOutlet weak var confirmPasswordTextField: KaedeTextField!
    
    @IBOutlet weak var registerButtonView: UIView!
    @IBOutlet weak var registerButton: ZFRippleButton!
    
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
        
        nameTextField.placeholderColor = UIColor.white
        emailTextField.placeholderColor = UIColor.white
        passwordTextField.placeholderColor = UIColor.white
        confirmPasswordTextField.placeholderColor = UIColor.white
        
    }
    
    
    func setFormAttributes() {
        
        inputsView.layer.cornerRadius = 6
        inputsView.layer.masksToBounds = true
        inputsView.layer.borderColor = UIColor.white.cgColor
        inputsView.layer.borderWidth = 1
        
        registerButtonView.layer.cornerRadius = 6
        registerButtonView.layer.borderColor = UIColor.white.cgColor
        registerButtonView.layer.borderWidth = 1
        registerButton.layer.cornerRadius = 6
    }
    
    
    @IBAction func logginToggleButtonPressed(_ sender: UIButton) {
        
        performSegue(withIdentifier: "LoginToggle", sender: nil)

    }
    
    func isValidName(name:String) -> Bool {
        // print("validate calendar: \(testStr)")
        let nameRegEx = "^[a-zA-Z]+$"
        
        let nameTest = NSPredicate(format:"SELF MATCHES %@", nameRegEx)
        return nameTest.evaluate(with: name)
    }
    
    
    @IBAction func registerButtonPressed(_ sender: UIButton) {
        
        if isValidName(name: nameTextField.text!) != true {
            self.alertMessage(alertAction: AlertAction(title: "Name Invalid", style: .cancel) { action in
            })
        }
    if passwordTextField.text! == confirmPasswordTextField.text! {
        FIRAuth.auth()?.createUser(withEmail: emailTextField.text!, password: passwordTextField.text!, completion: { (user, error) in
            if self.nameTextField.text == nil || self.emailTextField.text == nil || self.passwordTextField.text == nil || self.confirmPasswordTextField.text == nil {
                self.alertMessage(alertAction: AlertAction(title: "Fields Cannot Be Blank", style: .cancel) { action in
                    return
                })
            }
            if error != nil {
                print(error!)
                if self.nameTextField.text == nil || self.emailTextField.text == nil || self.passwordTextField.text == nil || self.confirmPasswordTextField.text == nil {
                    self.alertMessage(alertAction: AlertAction(title: "Fields Cannot Be Blank", style: .cancel) { action in
                        return
                    })
                }
                else if let errCode = FIRAuthErrorCode(rawValue: error!._code) {
                    
                    switch errCode {
                    case .errorCodeInvalidEmail:
                        self.alertMessage(alertAction: AlertAction(title: "Email Invalid", style: .cancel) { action in
                        })
                        
                    case .errorCodeEmailAlreadyInUse:
                        self.alertMessage(alertAction: AlertAction(title: "Email In Use", style: .cancel) { action in
                        })
                    case .errorCodeInternalError:
                        self.alertMessage(alertAction: AlertAction(title: "Password Blank", style: .cancel) { action in
                        })
                    case .errorCodeWeakPassword:
                        self.alertMessage(alertAction: AlertAction(title: "Password Too Short", style: .cancel) { action in
                        })
                    case .errorCodeAccountExistsWithDifferentCredential:
                        self.alertMessage(alertAction: AlertAction(title: "User Not Found", style: .cancel) { action in
                        })
                    
                    default:
                        print("Create User Error: \(error!)")
                        self.alertMessage(alertAction: AlertAction(title: "Error Registering", style: .cancel) { action in
                        })
                    }
                }
                
            }
            
            guard let uid = user?.uid else {
                return
            }
            
            let ref = FIRDatabase.database().reference(fromURL: "https://intentiontracker-cfbda.firebaseio.com")
            let userReference = ref.child("users").child(uid)
            let values = ["name": self.nameTextField.text, "email": self.emailTextField.text]
            
            userReference.updateChildValues(values, withCompletionBlock: { (err, ref) in
                if err != nil {
                    print(err!)
                }
            })
            
            
        })
    }
    else {
        print("Passwords do not match")
        self.alertMessage(alertAction: AlertAction(title: "Passwords Don't Match", style: .cancel) { action in
        })
    }
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

