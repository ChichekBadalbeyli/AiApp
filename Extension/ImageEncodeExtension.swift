//
//  ImageEncodeExtension.swift
//  AI
//
//  Created by Chichek on 27.09.24.
//

import Foundation
import UIKit

class ImageEncode {
    
    static func encodeImageToBase64(_ image: UIImage) -> String? {
        guard let imageData = image.jpegData(compressionQuality: 0.8) else { return nil }
        return imageData.base64EncodedString(options: .lineLength64Characters)
    }
    
}
