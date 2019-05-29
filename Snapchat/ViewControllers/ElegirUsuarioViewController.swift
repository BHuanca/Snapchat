//
//  ElegirUsuarioViewController.swift
//  Snapchat
//
//  Created by Bladimir Huanca Huarachi on 16/05/19.
//  Copyright © 2019 Bladimir Huanca Huarachi. All rights reserved.
//

import UIKit
import Firebase

class ElegirUsuarioViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var listaUsuarios: UITableView!
    var usuarios:[Usuario] = []
    var imagenURL = ""
    var descrip = ""
    var imagenID = ""
    
    var AudioURL = ""
    var descripAudio = ""
    var AudioID = ""
    
    var Recibido = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        listaUsuarios.delegate = self
        listaUsuarios.dataSource = self
        
        Database.database().reference().child("usuarios").observe(DataEventType.childAdded, with: {(snapshot) in
            //print("-----------" + \(snapshot) + "-----------")
            print(snapshot)
            
            let usuario = Usuario()
            usuario.email = (snapshot.value as! NSDictionary)["email"] as! String
            usuario.uid = snapshot.key
            self.usuarios.append(usuario)
            self.listaUsuarios.reloadData()
            
        })
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return usuarios.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        let usuario = usuarios[indexPath.row]
        cell.textLabel?.text = usuario.email
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let snap = Snap()
        
        let usuario = usuarios[indexPath.row]
        let snapImagen = ["from" : Auth.auth().currentUser?.email, "descripcion" : descrip, "imagenURL": imagenURL, "imagenID" : imagenID, "AudioURL": AudioURL, "AudioID" : AudioID]
        
        //let snapAudio = ["from" : Auth.auth().currentUser?.email, "descripcion" : descripAudio, "AudioURL": AudioURL, "AudioID" : AudioID]
        
    Database.database().reference().child("usuarios").child(usuario.uid).child("snaps").childByAutoId().setValue(snapImagen)
        
        
        /*else {
            Database.database().reference().child("usuarios").child(usuario.uid).child("snaps").childByAutoId().setValue(snapAudio)
        }*/
        
        navigationController?.popViewController(animated: true)
        
    }

}
