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

class SnapsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet weak var tablaSnaps: UITableView!
    var userDefault = UserDefaults()
    var snaps:[Snap] = []
    var snaps2:[Snap2] = []
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if snaps.count == 0{
            return 1
        }else {
            return snaps.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: "mycell")
        if snaps.count == 0{
            cell.textLabel?.text = "No tienes Snaps 😕"
        }else {
            let snap = snaps[indexPath.row]
            cell.textLabel?.text = "El correo: \(snap.from)"
            cell.detailTextLabel?.text = "Te envio una imagen y un audio"
        }
        return cell
    }
    
    /*override func viewDidLoad() {
        super.viewDidLoad()
        tablaSnaps.delegate = self
        tablaSnaps.dataSource = self
        Database.database().reference().child("usuarios").child((Auth.auth().currentUser?.uid)!).child("snaps").observe(DataEventType.childAdded, with: {(snapshot) in
            let snap = Snap()
            snap.imagenURL = (snapshot.value as! NSDictionary)["imagenURL"] as! String
            snap.from = (snapshot.value as! NSDictionary)["from"] as! String
            snap.descrip = (snapshot.value as! NSDictionary)["descripcion"] as! String
            snap.id = snapshot.key
            snap.imagenID = (snapshot.value as! NSDictionary)["imagenID"] as! String
            self.snaps.append(snap)
            self.tablaSnaps.reloadData()
        })
        
        Database.database().reference().child("usuarios").child((Auth.auth().currentUser?.uid)!).child("snaps").observe(DataEventType.childRemoved, with: {(snapshot) in
            var iterator = 0
            for snap in self.snaps {
                if snap.id == snapshot.key {
                    self.snaps.remove(at: iterator)
                }
                iterator += 1
            }
            self.tablaSnaps.reloadData()
        })
        
    }*/
    override func viewDidLoad() {
        super.viewDidLoad()
        tablaSnaps.delegate = self
        tablaSnaps.dataSource = self
        
        Database.database().reference().child("usuarios").child((Auth.auth().currentUser?.uid)!).child("snaps").observe(DataEventType.childAdded, with: {(snapshot) in
            let snap = Snap()
            snap.imagenURL = (snapshot.value as! NSDictionary)["imagenURL"] as! String
            snap.from = (snapshot.value as! NSDictionary)["from"] as! String
            snap.descrip = (snapshot.value as! NSDictionary)["descripcion"] as! String
            snap.id = snapshot.key
            snap.imagenID = (snapshot.value as! NSDictionary)["imagenID"] as! String
            self.snaps.append(snap)
            //print(self.snaps)
            self.tablaSnaps.reloadData()
        })
       
        Database.database().reference().child("usuarios").child((Auth.auth().currentUser?.uid)!).child("snaps").observe(DataEventType.childRemoved, with: {(snapshot) in
            var iterator = 0
            for snap in self.snaps{
                if snap.id == snapshot.key{
                    self.snaps.remove(at: iterator)
                }
                iterator += 1
            }
            self.tablaSnaps.reloadData()
        })
        
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
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let snap = snaps[indexPath.row]
        performSegue(withIdentifier: "versnapsegue", sender: snap)
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "versnapsegue" {
            let siguienteVC = segue.destination as! VerSnapViewController
            siguienteVC.snap = sender as! Snap
        }
    }
    
    
    @IBAction func enviarTapped(_ sender: Any) {
        self.performSegue(withIdentifier: "enviarImagenSegue", sender: nil)
        /*
        let alerta = UIAlertController(title: "Enviar", message: "Eliga una de las opciones que desee enviar", preferredStyle: .alert)
        let btnImagen = UIAlertAction(title: "Imagen", style: .default, handler: {
            (UIAlertAction) in
            self.performSegue(withIdentifier: "enviarImagenSegue", sender: nil)
        })
        let btnAudio = UIAlertAction(title: "Audio", style: .default, handler: {
            (UIAlertAction) in
            self.performSegue(withIdentifier: "enviarAudioSegue", sender: nil)
            
        })
        alerta.addAction(btnImagen)
        alerta.addAction(btnAudio)
        alerta.addAction(UIAlertAction(title: "Cancelar", style: .default, handler: nil))
        
        self.present(alerta, animated: true, completion: nil)
 */
        
    }
    
}
