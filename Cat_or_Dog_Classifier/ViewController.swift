//
//  ViewController.swift
//  Cat_or_Dog_Classifier
//
//  Created by Dawid Kubicki on 16/12/2020.
//

import UIKit
import CoreML
import Vision

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    let imagePicker = UIImagePickerController()

    @IBOutlet weak var imageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        imagePicker.delegate = self
        imagePicker.sourceType = .camera
        imagePicker.allowsEditing = false
    }

    
    func detect(image: CIImage){
        //model VNCoreMLModel
        guard let model = try? VNCoreMLModel(for: ImageClassifier_1().model) else {
            fatalError("Could not get model")
        }
        //request to model VNCoreMLRequest
        let request = VNCoreMLRequest(model: model) { (request, error) in
            guard let results = request.results as? [VNClassificationObservation] else {
                fatalError("Could not downcast results as VNClassificationObservation")
            }
            
            if let firstResult = results.first {
                self.navigationItem.title = firstResult.identifier
            }
        }
        //handler to image request handler
        let handler = VNImageRequestHandler(ciImage: image)
        
        do {
            try handler.perform([request])
        } catch  {
            print(error)
        }
    }
    
    //MARK: - Take picture handle
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let userPickedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            imageView.image = userPickedImage
            
            guard let ciimage = CIImage(image: userPickedImage) else {
                fatalError("Could not save as CIIimage ")
            }
            
            detect(image: ciimage)
        }
        
        imagePicker.dismiss(animated: true, completion: nil)
        
    }
    
    @IBAction func takePicture(_ sender: UIBarButtonItem) {
        present(imagePicker, animated: true, completion: nil)
    }
}

