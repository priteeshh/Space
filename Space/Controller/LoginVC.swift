//
//  ViewController.swift
//  Space
//
//  Created by Preeteesh Remalli on 06/09/21.
//

import UIKit

class LoginVC: UIViewController {
    
    @IBOutlet weak var orbitImageView: UIImageView!
    @IBOutlet weak var innerOrbitImageView: UIImageView!
    @IBOutlet weak var userNameTF: AppTextField!
    @IBOutlet weak var passwordTF: AppTextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.userNameTF.text = "Preteesh"
        self.passwordTF.text = "1234"


    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //titleLbl.text = self.user?.username
        // Animate orbits to slowly rotate
        orbitImageView.startRotating(duration: 25, clockwise: false, delay: 1)
        innerOrbitImageView.startRotating(duration: 20, clockwise: true, delay: 1)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    @IBAction func loginButtonTapped(_ sender: Any) {
        
    }
    @IBAction func signInButtonTapped(_ sender: Any){
        
    }
}
