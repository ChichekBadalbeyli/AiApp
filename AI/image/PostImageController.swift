//
//  PostImageController.swift
//  AI
//
//  Created by Chichek on 04.09.24.
//

import UIKit

protocol PostImageControllerDelegate: AnyObject {
    func didSelectImage(_ image: UIImage, description: String)
}

class PostImageController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    let imagePicker = UIImagePickerController()
    var selectedImage: UIImage?
    weak var delegate: PostImageControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imagePicker.delegate = self
    }
    
    @IBAction func imageAction(_ sender: Any) {
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
            imagePicker.sourceType = .photoLibrary
            present(imagePicker, animated: true, completion: nil)
        }
    }
    func sendImageForDescription(base64Image: String, originalImage: UIImage, completion: @escaping (Result<String, Error>) -> Void) {
        let networkManager = ImageNetworkManager()
        networkManager.sendImageRequest(with: originalImage) { result in
            completion(result)
        }
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let selectedImage = info[.originalImage] as? UIImage {
            self.selectedImage = selectedImage
            
            if let base64Image = encodeImageToBase64(selectedImage) {
                sendImageForDescription(base64Image: base64Image, originalImage: selectedImage) { [weak self] result in
                    DispatchQueue.main.async {
                        guard let self = self else { return }
                        switch result {
                        case .success(let description):
                            // Pass the original UIImage along with the fetched description
                            self.delegate?.didSelectImage(selectedImage, description: description)
                        case .failure(let error):
                            print("Error getting description: \(error.localizedDescription)")
                            self.delegate?.didSelectImage(selectedImage, description: "Failed to get description.")
                        }
                        
                        self.dismissImagePickerAndNavigate(picker)
                    }
                }
            } else {
                print("Failed to encode image to Base64")
                picker.dismiss(animated: true, completion: nil)
            }
        } else {
            picker.dismiss(animated: true, completion: nil)
        }
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
    private func dismissImagePickerAndNavigate(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true) {
            if let imageVC = self.storyboard?.instantiateViewController(withIdentifier: "ImageController") as? ImageController {
                self.present(imageVC, animated: true, completion: nil)
            }
        }
    }
    
    func encodeImageToBase64(_ image: UIImage) -> String? {
        guard let imageData = image.jpegData(compressionQuality: 0.8) else {
            return nil
        }
        return imageData.base64EncodedString()
    }
    
}
