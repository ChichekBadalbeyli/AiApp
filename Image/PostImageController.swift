//
//  PostImageController.swift
//  AI
//
//  Created by Chichek on 04.09.24.
//

import Alamofire
import UIKit

class PostImageController: UIViewController {
    var controller = ImageController()
    let imageManager: ImageManagerProtocol = ImageManager()
    var selectedImage: UIImage?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func imageAction(_ sender: Any) {
        selectImage()
    }
    
    func selectImage() {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = .photoLibrary
        self.present(imagePicker, animated: true, completion: nil)
    }
    
    func processSelectedImage(_ image: UIImage) {
        imageManager.processImage(image: image, prompt: "Describe the selected image") { [weak self] description, error in
            guard let self = self else { return }
            if let error = error {
                print("Error: \(error)")
            } else if let description = description {
                self.showImageAndDescription(image: image, description: description)
            }
        }
    }
    
    func showImageAndDescription(image: UIImage, description: String) {
        let coordinator = ImageCoordinator(navigator: self.navigationController ?? UINavigationController())
        coordinator.start(image: image, description: description)
    }
}

extension PostImageController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let selectedImage = info[.originalImage] as? UIImage {
            self.selectedImage = selectedImage
            picker.dismiss(animated: true) {
                self.processSelectedImage(selectedImage)
            }
        }
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
}
