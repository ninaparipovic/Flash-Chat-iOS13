//
//  MessageCell.swift
//  Flash Chat iOS13
//
//  Created by Nina Paripovic on 4/19/21.
//  Copyright © 2021 Angela Yu. All rights reserved.
//

import UIKit

class MessageCell: UITableViewCell {
    @IBOutlet weak var MessageBubble: UIView!
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var meImage: UIImageView!
    @IBOutlet weak var youImage: UIImageView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        MessageBubble.layer.cornerRadius = MessageBubble.frame.size.height / 5
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
