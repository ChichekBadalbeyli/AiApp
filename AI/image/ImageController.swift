//
//  ImageController.swift
//  AI
//
//  Created by Chichek on 06.09.24.
//

import UIKit

class ImageController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet var tableView: UITableView!
    var selectedImage: UIImage?
    var imageDescription: String?
    
    var images: [(image: UIImage, description: String)] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        
        if let image = selectedImage, let description = imageDescription {
            print("Image and description received: \(description)")
            images.append((image: image, description: description))
        }
        tableView.reloadData()
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return images.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ImageCell", for: indexPath) as! ImageCell
        let imageData = images[indexPath.row]
        print("Displaying image: \(imageData.description)")
        cell.maImage.image = imageData.image
        cell.imageDescription.text = imageData.description
        return cell
    }
}
