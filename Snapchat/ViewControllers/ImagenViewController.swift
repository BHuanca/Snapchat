//
//  ImagenViewController.swift
//  Snapchat
//
//  Created by Bladimir Huanca Huarachi on 16/05/19.
//  Copyright © 2019 Bladimir Huanca Huarachi. All rights reserved.
//

import UIKit
import Firebase
import AVFoundation

class ImagenViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBOutlet weak var grabarButton: UIButton!
    
    @IBOutlet weak var reproducirButton: UIButton!
    
    @IBOutlet weak var imageView: UIImageView!
    
    @IBOutlet weak var descripcionTextField: UITextField!
    
    @IBOutlet weak var elegirContactoBoton: UIButton!
    
    var imagePicker = UIImagePickerController()
    var imagenID = NSUUID().uuidString
    
    var grabarAudio:AVAudioRecorder?
    var reproducirAudio:AVAudioPlayer?
    var audioURL:URL?
    var AudioID = NSUUID().uuidString
    
    var tiempo:AVAudioPlayer?

    var audioURlEnviar = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imagePicker.delegate = self
        elegirContactoBoton.isEnabled = false
        configurarGrabacion()
    }
    @IBAction func mediaTapped(_ sender: Any) {
        imagePicker.sourceType = .savedPhotosAlbum
        imagePicker.allowsEditing = false
        present(imagePicker, animated: true, completion: nil)
    }
    @IBAction func camaraTapped(_ sender: Any) {
        imagePicker.sourceType = .camera
        //imagePicker.sourceType = .savedPhotosAlbum
        imagePicker.allowsEditing = false
        present(imagePicker, animated: true, completion: nil)
    }
    
    @IBAction func elegirContactoTapped(_ sender: Any) {
        //performSegue(withIdentifier: "seleccionarContactoSegue", sender: nil)
        self.elegirContactoBoton.isEnabled = false
        
        let snap = Snap()
        
        let imagenesFolder = Storage.storage().reference().child("imagenes")
        let imagenData = imageView.image?.jpegData(compressionQuality: 0.50)
        let cargarImagen = imagenesFolder.child("\(imagenID).jpg")
            cargarImagen.putData(imagenData!, metadata: nil) {
            (metadata, error) in
            if error != nil {
                self.mostrarAlerta(titulo: "Error", mensaje: "Se produjo un error al subir la imagen. Verifique su conexion a internet y vuelva a intentarlo", accion: "Aceptar")
                self.elegirContactoBoton.isEnabled = true
                print("Ocurrio un error al subir la imagen: \(error!)")
                return
            }else {
                cargarImagen.downloadURL(completion: {(url, error) in
                    guard let enlaceURL = url else {
                        self.mostrarAlerta(titulo: "Error", mensaje: "Se produjo un error al obtener la informacion de imagen", accion: "Cancelar")
                        self.elegirContactoBoton.isEnabled = true
                        print("Ocurrio un error al obtener informacion de imagen \(error!)")
                        // self.ImagenURLEnviar = (url?.absoluteString)!
                        return
                      //  self.ImagenURLEnviar = (url?.absoluteString)!
                    }
                    self.performSegue(withIdentifier: "seleccionarContactoSegue", sender: url?.absoluteString)
                })
            }
        }
        
        let audiosFolder = Storage.storage().reference().child("audios")
        let grabacion = NSData(contentsOf: audioURL!)! as Data
        let cargarAudio = audiosFolder.child("\(AudioID).m4a")
        cargarAudio.putData(grabacion, metadata: nil) {
            (metadata, error) in
            if error != nil {
                self.mostrarAlerta(titulo: "Error", mensaje: "Se produjo un error al subir el audio. Verifique su conexion a internet y vuelva a intentarlo", accion: "Aceptar")
                //self.elegirContactoBoton.isEnabled = true
                print("Ocurrio un error al subir el Audio: \(error!)")
                return
            }else {
                cargarAudio.downloadURL(completion: {(url2, error) in
                    guard let enlaceURL = url2 else {
                        self.mostrarAlerta(titulo: "Error", mensaje: "Se produjo un error al obtener la informacion del audio", accion: "Cancelar")
                        //self.elegirContactoBoton.isEnabled = true
                        print("Ocurrio un error al obtener informacion del audio \(error!)")
                        return
                    }
                    self.audioURlEnviar = (url2?.absoluteString)!
                })
            }
        }
        
        
        /*
        let alertaCarga = UIAlertController(title: "Cargando Imagen...", message: "O%", preferredStyle: .alert)
        let progresoCarga:UIProgressView = UIProgressView(progressViewStyle: .default)
        cargarImagen.observe(.progress) { (snapshot) in
            let porcentaje = Double(snapshot.progress!.completedUnitCount) / Double(snapshot.progress!.totalUnitCount)
            print(porcentaje)
            progresoCarga.setProgress(Float(porcentaje), animated: true)
            progresoCarga.frame = CGRect(x: 10, y: 70, width: 250, height: 0)
            alertaCarga.message = String(round(porcentaje*100.0)) + " %"
            if porcentaje>=1.0 {
                alertaCarga.dismiss(animated: true, completion: nil)
            }
        }
        let btnOK = UIAlertAction(title: "Aceptar", style: .default, handler: nil)
        alertaCarga.addAction(btnOK)
        alertaCarga.view.addSubview(progresoCarga)
        present(alertaCarga, animated: true, completion: nil)*/
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage
        imageView.image = image
        imageView.backgroundColor = UIColor.clear
        elegirContactoBoton.isEnabled = true
        imagePicker.dismiss(animated: true, completion: nil)
    }
    
   
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        /*let imagenesFolder = Storage.storage().reference().child("imagenes")
        let imagenData = imageView.image?.jpegData(compressionQuality: 0.50)
        imagenesFolder.child("imagenes.png").putData(imagenData!, metadata: nil) {
            (metadata, error) in
            if error != nil {
                print("Ocurrio un error al subir la imagen: \(error!)")
            }
        }*/
        let snap = Snap()
        let siguienteVC = segue.destination as! ElegirUsuarioViewController
        siguienteVC.Recibido = "Imagen"
        
        siguienteVC.imagenURL = sender as! String
        siguienteVC.descrip = descripcionTextField.text!
        siguienteVC.imagenID = imagenID
        
        siguienteVC.AudioURL = self.audioURlEnviar
        siguienteVC.AudioID = AudioID
        
        
    }
    
    func mostrarAlerta(titulo: String, mensaje: String, accion: String) {
        let alerta = UIAlertController(title: titulo, message: mensaje, preferredStyle: .alert)
        let btnCANCELOK = UIAlertAction(title: accion, style: .default, handler: nil)
        alerta.addAction(btnCANCELOK)
        present(alerta, animated: true, completion: nil)
    }
    
    
    @IBAction func grabarTapped(_ sender: Any) {
        if grabarAudio!.isRecording {
            //detener la grabacion
            grabarAudio?.stop()
            //cambiar texto del boton grabar
            grabarButton.setTitle("GRABAR", for: .normal)
            reproducirButton.isEnabled = true
            //agregarButton.isEnabled = true
            
        }else {
            //empezar a grabar
            grabarAudio?.record()
            //cambiar el texto del boton grabar a detener
            grabarButton.setTitle("DETENER", for: .normal)
            reproducirButton.isEnabled = false
        }
    }
    @IBAction func reproducirTapped(_ sender: Any) {
        do {
            try reproducirAudio = AVAudioPlayer(contentsOf: audioURL!)
            reproducirAudio!.play()
            print("Reproduciendo...")
        }catch{
            print("Sucedio un error al reproducir")
        }
    }
    
    func configurarGrabacion(){
        do {
            //creando sesion de audio
            let session = AVAudioSession.sharedInstance()
            try session.setCategory(AVAudioSession.Category.playAndRecord, mode: AVAudioSession.Mode.default, options: [])
            try session.overrideOutputAudioPort(.speaker)
            try session.setActive(true)
            
            //creando direccion para el archivo de audio
            let basePath:String = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first!
            let pathComponents = [basePath, "audio.m4a"]
            audioURL = NSURL.fileURL(withPathComponents: pathComponents)!
            
            //impresion de ruta donde se guarda los archivos
            print("***********************")
            print(audioURL!)
            print("***********************")
            
            //crear opciones para el grabador de audio
            var settings:[String:AnyObject] = [:]
            settings[AVFormatIDKey] = Int(kAudioFormatMPEG4AAC) as AnyObject?
            settings[AVSampleRateKey] = 44100.0 as AnyObject?
            settings[AVNumberOfChannelsKey] = 2 as AnyObject?
            
            //crear el objeto de grabacion de audio
            grabarAudio = try AVAudioRecorder(url: audioURL!, settings: settings)
            grabarAudio!.prepareToRecord()
            
        }catch let error as NSError {
            print(error)
        }
    }
    
}
