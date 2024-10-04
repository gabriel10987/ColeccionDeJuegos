//
//  JuegosViewController.swift
//  ColeccionDeJuegos
//
//  Created by Gabriel Anderson Ccama Apaza on 2/10/24.
//

import UIKit

class JuegosViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIPickerViewDelegate, UIPickerViewDataSource {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var nombreTextField: UITextField!
    @IBOutlet weak var descripcionTextField: UITextField!
    @IBOutlet weak var categoriaPickerView: UIPickerView!
    @IBOutlet weak var agregarActualizarBoton: UIButton!
    
    
    var imagePicker = UIImagePickerController()
    
    var juego:Juego? = nil
    
    let categorias = ["Acción", "Aventura", "Deportes", "Estrategia", "Simulación", "Puzzle"]
    var categoriaSeleccionada: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imagePicker.delegate = self
        // ESTO SE AGREGÓ
        categoriaPickerView.delegate = self
        categoriaPickerView.dataSource = self
        
        if juego != nil {
            imageView.image = UIImage(data: (juego!.imagen!) as Data)
            nombreTextField.text = juego!.nombre
            // ESTO SE AGREGÓ
            descripcionTextField.text = juego!.descripcion
            if let categoria = juego!.categoria {
                if let index = categorias.firstIndex(of: categoria) {
                    categoriaPickerView.selectRow(index, inComponent: 0, animated: true)
                }
            }
            agregarActualizarBoton.setTitle("Actualizar", for: .normal)
        }
        
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return categorias.count
    }

    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return categorias[row]
    }

    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        categoriaSeleccionada = categorias[row]
    }
    
    @IBAction func fotosTapped(_ sender: Any) {
        imagePicker.sourceType = .photoLibrary
        present(imagePicker, animated: true,
            completion: nil)
    }
    
    @IBAction func camaraTapped(_ sender: Any) {
    }
    
    @IBAction func agregarTapped(_ sender: Any) {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        
        if juego != nil {
            juego!.nombre! = nombreTextField.text!
            juego!.descripcion! = descripcionTextField.text!
            juego!.imagen = imageView.image?.jpegData(compressionQuality: 0.50)
            juego!.categoria = categoriaSeleccionada
        } else {
            let juego = Juego(context: context)
            juego.nombre = nombreTextField.text
            juego.descripcion = descripcionTextField.text
            juego.imagen = imageView.image?.jpegData(compressionQuality: 0.50)
            juego.categoria = categoriaSeleccionada
        }
        (UIApplication.shared.delegate as! AppDelegate).saveContext()
        navigationController?.popViewController(animated: true)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let imagenSeleccionada = info[.originalImage] as? UIImage
        imageView.image = imagenSeleccionada
        imagePicker.dismiss(animated: true, completion: nil)
    }
        
}

