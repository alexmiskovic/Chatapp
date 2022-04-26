
import Foundation
import UIKit
import FirebaseAuth
import simd

class AuthViewController: UIViewController{
    
    @IBOutlet weak var activityInd: UIActivityIndicatorView!
    
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var emailAddressInput: UITextField!
    
    @IBOutlet weak var forgotPasswordButton: UIButton!
    @IBOutlet weak var registerButton: UIButton!
    
    @IBOutlet weak var passwordInput: UITextField!
    
    override func viewDidLoad() {
        isModalInPresentation = true
    }
    
    @IBAction func loginTapped(_ sender: UIButton) {
        if !inputValid() {
            return
        }
        activateUI(enabled: false)
        let email = emailAddressInput.text!
        let password = passwordInput.text!
        
        Auth.auth().signIn(withEmail: email, password: password, completion: {(user, error) in
            if error != nil {
                Utilities().showAlert(title: "Error", message: error!.localizedDescription, vc: self)
            } else {
            self.dismiss(animated: true, completion: nil)
            }
            self.activateUI(enabled: true)
        })
    }
    
    
    @IBAction func registerTapped(_ sender: UIButton) {
        if !inputValid() {
            return
        }
        activateUI(enabled: false)
        let email = emailAddressInput.text!
        let password = passwordInput.text!
        
        Auth.auth().createUser(withEmail: email, password: password, completion: {(user, error) in
            if error != nil {
                Utilities().showAlert(title: "Error", message: error!.localizedDescription, vc: self)
            } else {
                self.dismiss(animated: true, completion: nil)
            }
            self.activateUI(enabled: true)
        } )
    }
    
    
    @IBAction func forgotTapped(_ sender: UIButton) {
        
        
        if !emailValid() {
            Utilities().showAlert(title: "Error", message: "Email not valid", vc: self)
            return
            
        }
        activateUI(enabled: false)

        Auth.auth().sendPasswordReset(withEmail: emailAddressInput.text!) { (err) in
            self.activateUI(enabled: true)
            if let e = err {
                Utilities().showAlert(title: "Error", message: e.localizedDescription, vc: self)
                return
            }
            Utilities().showAlert(title: "Success", message: "Check your email..", vc: self)
        }
        
    }
    
    func activateUI(enabled: Bool){
        loginButton.isEnabled = enabled
        registerButton.isEnabled = enabled
        forgotPasswordButton.isEnabled = enabled
        if enabled {
            activityInd.stopAnimating()
        } else {
            activityInd.startAnimating()
        }
    }
    func emailValid () -> Bool{
        let email = emailAddressInput.text!
        if email.count < 6 {
            return false
        } else{
            return true
        }
    }
    
    func inputValid () -> Bool {
        let pass = passwordInput.text!
        if !emailValid() || pass.count < 5 {
            Utilities().showAlert(title: "Error", message: "Email or password too short", vc: self)
            return false
        }
        return true
    }
    
    
    
}
