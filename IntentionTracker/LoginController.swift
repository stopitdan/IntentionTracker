//
//  ViewController.swift
//  IntentionTracker
//
//  Created by Dan Wiegand on 1/5/17.
//  Copyright © 2017 Stop It. All rights reserved.
//

import UIKit
import Firebase

class LoginController: UIViewController {

    @IBOutlet weak var inputsView: UIView!
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setFormAttributes()
        changePlaceholderColors()
        
    
    }
    
    func changePlaceholderColors() {
        
        let whiteAttribute = [NSForegroundColorAttributeName: UIColor.white]
        
        emailTextField.attributedPlaceholder = NSAttributedString(string: "Email", attributes: whiteAttribute)
        passwordTextField.attributedPlaceholder = NSAttributedString(string: "Password", attributes: whiteAttribute)
        
    }
    
    
    func setFormAttributes() {
        
        inputsView.layer.cornerRadius = 6
        inputsView.layer.masksToBounds = true
        inputsView.layer.borderColor = UIColor.white.cgColor
        inputsView.layer.borderWidth = 1
    }
    

    @IBAction func registerToggleButtonPressed(_ sender: UIButton) {
        
        performSegue(withIdentifier: "RegisterToggle", sender: nil)

    }
    
    @IBAction func loginButtonPressed(_ sender: UIButton) {
        
        FIRAuth.auth()?.signIn(withEmail: emailTextField.text!, password: passwordTextField.text!, completion: { (user, error) in
            if error != nil {
                print(error!)
            }
        })
        
    }
    

}

