//
//  MessageViewCell.swift
//  AI
//
//  Created by Chichek on 27.07.24.
//

import UIKit

class MessageViewCell: UITableViewCell {
    
    @IBOutlet weak var messageLabel: UILabel!
    
    @IBOutlet weak var pin: UIButton!
    
    var pinAction: (()-> Void)?
    override func awakeFromNib() {
        super.awakeFromNib()
        messageLabel.layer.cornerRadius = 10
        messageLabel.layer.masksToBounds = true
        pin.isHidden = true
    }
    
    func configure(with message: ChatMessage, isPinned: Bool) {
        messageLabel.text = message.content
        if message.isUser {
            messageLabel.backgroundColor = .lightGray
            messageLabel.textAlignment = .right
            NSLayoutConstraint.activate([
                messageLabel.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant: 0),
                messageLabel.leadingAnchor.constraint(greaterThanOrEqualTo: self.contentView.centerXAnchor, constant: 300)])
        } else {
            messageLabel.backgroundColor = .white
            messageLabel.textAlignment = .left
        }
        
        pin.isHidden = !isPinned
    }
    
    @IBAction func pinAction(_ sender: Any) {
        pinAction?()
    }
}
