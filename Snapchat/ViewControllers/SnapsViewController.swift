//
//  SnapsViewController.swift
//  Snapchat
//
//  Created by Bladimir Huanca Huarachi on 16/05/19.
//  Copyright © 2019 Bladimir Huanca Huarachi. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import GoogleSignIn

class SnapsViewController: UIViewController {
    
    var userDefault = UserDefaults()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func cerrarSesionTapped(_ sender: Any) {
        do {
            try Auth.auth().signOut()
            userDefault.removeObject(forKey: "usersignedin")
            userDefault.synchronize()
            dismiss(animated: true, completion: nil)
        }catch let error as NSError{
            print("Sucedio el siguiente error: \(error.localizedDescription)")
        }
        
        //self.performSegue(withIdentifier: "loginsesionsegue", sender: nil)
    }
    
    
    
    
}
