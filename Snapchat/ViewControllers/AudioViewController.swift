//
//  AudioViewController.swift
//  Snapchat
//
//  Created by Bladimir Huanca Huarachi on 28/05/19.
//  Copyright © 2019 Bladimir Huanca Huarachi. All rights reserved.
//

import UIKit
import AVFoundation
import Firebase

class AudioViewController: UIViewController {
    
    
    @IBOutlet weak var grabarButton: UIButton!
    
    @IBOutlet weak var reproducirButton: UIButton!
    @IBOutlet weak var nombreTextField: UITextField!
    
    @IBOutlet weak var agregarButton: UIButton!
    
    var grabarAudio:AVAudioRecorder?
    var reproducirAudio:AVAudioPlayer?
    var audioURL:URL?
    var AudioID = NSUUID().uuidString
    
    var tiempo:AVAudioPlayer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configurarGrabacion()
    }
    
    @IBAction func grabarTapped(_ sender: Any) {
        if grabarAudio!.isRecording {
            //detener la grabacion
            grabarAudio?.stop()
            //cambiar texto del boton grabar
            grabarButton.setTitle("GRABAR", for: .normal)
            reproducirButton.isEnabled = true
            agregarButton.isEnabled = true
            
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
    
    func mostrarAlerta(titulo: String, mensaje: String, accion: String) {
        let alerta = UIAlertController(title: titulo, message: mensaje, preferredStyle: .alert)
        let btnCANCELOK = UIAlertAction(title: accion, style: .default, handler: nil)
        alerta.addAction(btnCANCELOK)
        present(alerta, animated: true, completion: nil)
    }
    
    @IBAction func agregarTapped(_ sender: Any) {
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
                    self.performSegue(withIdentifier: "seleccionarContactoSegue", sender: url2?.absoluteString)
                })
            }
        }
        
        /*let grabacion = Grabacion(context: context)
        grabacion.nombre = nombreTextField.text
        grabacion.audio = NSData(contentsOf: audioURL!)! as Data*/
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {

        let siguienteVC = segue.destination as! ElegirUsuarioViewController
        siguienteVC.Recibido = "Audio"
        siguienteVC.AudioURL = sender as! String
        siguienteVC.descripAudio = nombreTextField.text!
        siguienteVC.AudioID = AudioID
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
