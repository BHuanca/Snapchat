//
//  CrearUsuarioViewController.swift
//  Snapchat
//
//  Created by Bladimir Huanca Huarachi on 20/05/19.
//  Copyright © 2019 Bladimir Huanca Huarachi. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth

class CrearUsuarioViewController: UIViewController {

    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var claveTextField: UITextField!
    @IBOutlet weak var nombreTextField: UITextField!
    @IBOutlet weak var apellidosTextField: UITextField!
    
    @IBOutlet weak var telefonoTextField: UITextField!
    @IBOutlet weak var sexoTextField: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    
    @IBAction func entrarButton(_ sender: Any) {
        //let user = emailTextField.text!
        do {
            Auth.auth().createUser(withEmail: self.emailTextField.text!, password: self.claveTextField.text!, completion: {(user, error) in
                //print("Intentando crear usuario...")
                var alert = UIAlertController(title: "", message: "", preferredStyle: .alert)
                if error != nil{
                    //print("Se presento el siguiente error al crear el usuario: \(error)")
                    alert = UIAlertController(title: "Error", message: "Se presento el siguiente error al crear el usuario: \(error)", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "Aceptar", style: .cancel, handler: nil))
                    self.present(alert, animated: true)
                }else{
                    //print("El usuario fue creado exitosamente!")
                    
                    let informacion = ["email" : user!.user.email, "nombre" : self.nombreTextField.text!, "apellidos" : self.apellidosTextField.text!, "telefono" : self.telefonoTextField.text!, "sexo" : self.sexoTextField.text!]

                    Database.database().reference().child("usuarios").child(user!.user.uid).setValue(informacion)
                    
                    let alerta = UIAlertController(title: "Exito", message: "Se registro correctamente", preferredStyle: .alert)
                    let btnOK = UIAlertAction(title: "Aceptar", style: .default, handler: {
                        (UIAlertAction) in
                        self.performSegue(withIdentifier: "iniciarsesionsegue", sender: nil)
                    })
                    alerta.addAction(btnOK)
                    self.present(alerta, animated: true, completion: nil)
                }
                
            })
        }catch{
            var alert = UIAlertController(title: "Error", message: "Sucedio algo en la creacion de usuarios", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Aceptar", style: .cancel, handler: nil))
            self.present(alert, animated: true)
        }
    }
    
    
    

}
