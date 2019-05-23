//
//  ViewController.swift
//  Snapchat
//
//  Created by Bladimir Huanca Huarachi on 9/05/19.
//  Copyright © 2019 Bladimir Huanca Huarachi. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import GoogleSignIn


class inicarSesionViewController: UIViewController, GIDSignInUIDelegate {

    
    @IBOutlet weak var emailTextField: UITextField!
    
    @IBOutlet weak var passwordTextField: UITextField!
    
    let userDefault = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        GIDSignIn.sharedInstance().uiDelegate = self
        //GIDSignIn.sharedInstance().signIn()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if userDefault.bool(forKey: "usersignedin") {
            performSegue(withIdentifier: "iniciarsesionsegue", sender: self)
        }
    }
    
    /*@IBAction func iniciarSesionTapped(_ sender: Any) {
        Auth.auth().signIn(withEmail: emailTextField.text!, password: passwordTextField.text!) {
            (user, error) in
            print("Intentando Iniciar Sesion")
            
            var alert = UIAlertController(title: "Did you bring your towel?", message: "It's recommended you bring your towel before continuing.", preferredStyle: .alert)
 
            if error != nil {
                //print("Se presento el siguiente error: \(error!)")
                alert = UIAlertController(title: "Error", message: "Se presento el siguiente error: \(error!)", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Aceptar", style: .cancel, handler: nil))
            }else{
                print("Inicio de sesion exitoso")
                //Database.database().reference().child("usuarios").child(user!.user.uid).child("email").setValue(user!.user.email)
                //Database.database().reference().child("usuarios").child(user!.user.uid).child("email").setValue(user!.user.email)
                Database.database().reference().child("usuarios").observe(DataEventType.childAdded, with: {(snapshot) in
                    
                    print(snapshot)
                    let usuario = (snapshot.value as! NSDictionary)["email"] as! String
                    
                    print("--------------" + usuario + "--------------")
                    alert = UIAlertController(title: "Datos", message: usuario, preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "Aceptar", style: .cancel, handler: nil))
                    self.present(alert, animated: true)
                })
                
                //alert = UIAlertController(title: "Exito!", message: "Inicio de sesion exitoso", preferredStyle: .alert)
                //alert.addAction(UIAlertAction(title: "Aceptar", style: .cancel, handler: nil))
            }
            //self.present(alert, animated: true)
        }
    }*/
    @IBAction func iniciarSesionTapped(_ sender: Any) {
        Auth.auth().signIn(withEmail: emailTextField.text!, password: passwordTextField.text!) {
            (user, error) in
            print("Intentando Iniciar Sesion")
            
            if error != nil {
                //print("Se presento el siguiente error: \(error)")
                /*Auth.auth().createUser(withEmail: self.emailTextField.text!, password: self.passwordTextField.text!, completion: {(user, error) in
                    print("Intentando crear usuario...")
                    if error != nil{
                        print("Se presento el siguiente error al crear el usuario: \(error)")
                    }else{
                        print("El usuario fue creado exitosamente!")
                        Database.database().reference().child("usuarios").child(user!.user.uid).child("email").setValue(user!.user.email)
                        
                        let alerta = UIAlertController(title: "Creacion de Usuario", message: "Usuario: \(self.emailTextField.text!) se creo correctamente", preferredStyle: .alert)
                        let btnOK = UIAlertAction(title: "Aceptar", style: .default, handler: {
                            (UIAlertAction) in
                            self.performSegue(withIdentifier: "iniciarsesionsegue", sender: nil)
                        })
                        alerta.addAction(btnOK)
                        self.present(alerta, animated: true, completion: nil)
                    }
                    
                })*/
                
                let alerta = UIAlertController(title: "Error", message: "Usuario no detectado, cree una cuenta porfavor", preferredStyle: .alert)
                let btnCrear = UIAlertAction(title: "Crear", style: .default, handler: {
                    (UIAlertAction) in
                    self.performSegue(withIdentifier: "crearusuariosegue", sender: nil)
                })
                alerta.addAction(btnCrear)
                alerta.addAction(UIAlertAction(title: "Cancelar", style: .default, handler: nil))
                
                self.present(alerta, animated: true, completion: nil)
                
            }else{
                print("Inicio de sesion exitoso")
                self.performSegue(withIdentifier: "iniciarsesionsegue", sender: nil)
            }
        }
    }
    
    /*@IBAction func cerrarSesionButton(_ sender: Any) {
        do {
            try Auth.auth().signOut()
        } catch let signOutError as NSError {
            print ("Error signing out: %@", signOutError)
        }
    }*/
    
    
    @IBAction func crearUsuarioButon(_ sender: Any) {
        //crearusuariosegue
        self.performSegue(withIdentifier: "crearusuariosegue", sender: nil)
    }
    
    
}

