//
//  ViewController.swift
//  IntentionTracker
//
//  Created by Dan Wiegand on 1/5/17.
//  Copyright © 2017 Stop It. All rights reserved.
//

import UIKit

class RegisterController: UIViewController {
    
    @IBOutlet weak var inputsView: UIView!
    
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var confirmPasswordTextField: UITextField!
    
    
    
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
        
        nameTextField.attributedPlaceholder = NSAttributedString(string: "Name", attributes: whiteAttribute)
        emailTextField.attributedPlaceholder = NSAttributedString(string: "Email", attributes: whiteAttribute)
        passwordTextField.attributedPlaceholder = NSAttributedString(string: "Password", attributes: whiteAttribute)
        confirmPasswordTextField.attributedPlaceholder = NSAttributedString(string: "Confirm Password", attributes: whiteAttribute)
        
    }
    
    
    func setFormAttributes() {
        
        inputsView.layer.cornerRadius = 6
        inputsView.layer.masksToBounds = true
        inputsView.layer.borderColor = UIColor.white.cgColor
        inputsView.layer.borderWidth = 1
    }
    
    
    @IBAction func logginToggleButtonPressed(_ sender: UIButton) {
        
        performSegue(withIdentifier: "LoginToggle", sender: nil)

        
    }
    
    @IBAction func registerToggleButtonPressed(_ sender: UIButton) {
        
        
    }
    
    
}
