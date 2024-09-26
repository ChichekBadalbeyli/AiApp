//
//  ImageCell.swift
//  AI
//
//  Created by Chichek on 06.09.24.
//

import UIKit

class ImageCell: UITableViewCell {
    
    @IBOutlet var maImage: UIImageView!
    
    @IBOutlet var imageDescription: UILabel!
    
    override func awakeFromNib() {
            super.awakeFromNib()
        }
        
        override func setSelected(_ selected: Bool, animated: Bool) {
            super.setSelected(selected, animated: animated)
        }
    
}
