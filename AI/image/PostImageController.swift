//
//  PostImageController.swift
//  AI
//
//  Created by Chichek on 04.09.24.
//

//import UIKit

//protocol PostImageControllerDelegate: AnyObject {
//    func didSelectImage(_ image: UIImage, description: String)
//}
//
//class PostImageController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
//    
//    let imagePicker = UIImagePickerController()
//    var selectedImage: UIImage?
//    var delegate: PostImageControllerDelegate?
//    
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        imagePicker.delegate = self
//    }


import Alamofire
import UIKit

class PostImageController: UIViewController {
    
    let imageManager: ImageManagerProtocol = ImageManager()
    var selectedImage: UIImage?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    @IBAction func imageAction(_ sender: Any) {
//        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
//              imagePicker.sourceType = .photoLibrary
//              present(imagePicker, animated: true, completion: nil)
//          }
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
                print("Image description: \(description)")
                // Navigate to ImageController after the image is processed
                self.showImageAndDescription(image: image, description: description)
            }
        }
    }

    // Function to navigate to ImageController and pass the image and description
    func showImageAndDescription(image: UIImage, description: String) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let imageController = storyboard.instantiateViewController(withIdentifier: "ImageController") as? ImageController {
            imageController.selectedImage = image
            imageController.imageDescription = description
            self.navigationController?.pushViewController(imageController, animated: true)
        }
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
//    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
//        if let selectedImage = info[.originalImage] as? UIImage {
//            print("Image selected successfully.")
//            self.selectedImage = selectedImage
//
//            let activityIndicator = UIActivityIndicatorView(style: .large)
//            activityIndicator.center = self.view.center
//            activityIndicator.startAnimating()
//            self.view.addSubview(activityIndicator)
//
//            // Log the request before starting
//            print("Sending image for description.")
//            
//            // Use the network manager to send the image and get a description
//            ImageNetworkManager.requestImageEdit(with: selectedImage, prompt: "Describe the selected image", endpoint: ChatEndpoint.chatEndpoint.rawValue) { [weak self] description, error in
//                DispatchQueue.main.async {
//                    activityIndicator.stopAnimating()
//                    activityIndicator.removeFromSuperview()
//
//                    guard let self = self else { return }
//
//                    if let error = error {
//                        print("Error in network request: \(error.localizedDescription)")
//                        let imageDescription = "Failed to get description."
//                        self.delegate?.didSelectImage(selectedImage, description: imageDescription)
//                        self.dismissImagePickerAndNavigate(picker, image: selectedImage, description: imageDescription)
//                        return
//                    }
//
//                    let imageDescription = description ?? "Failed to get description."
//                    print("Image description received: \(imageDescription)")
//                    self.delegate?.didSelectImage(selectedImage, description: imageDescription)
//                    self.dismissImagePickerAndNavigate(picker, image: selectedImage, description: imageDescription)
//                }
//            }
//        } else {
//            print("Failed to pick image.")
//            picker.dismiss(animated: true, completion: nil)
//        }
//    }
//
//    
//    private func dismissImagePickerAndNavigate(_ picker: UIImagePickerController, image: UIImage, description: String) {
//        picker.dismiss(animated: true) {
//            if let imageVC = self.storyboard?.instantiateViewController(withIdentifier: "ImageController") as? ImageController {
//                imageVC.selectedImage = image
//                imageVC.imageDescription = description
//                self.present(imageVC, animated: true, completion: nil)
//            }
//        }
//    }
//    
//    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
//        picker.dismiss(animated: true, completion: nil)
//    }

