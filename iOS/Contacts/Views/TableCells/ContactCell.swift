//
//  ContactCell.swift
//  Contacts
//
//  Created by Sushant Alone on 16/08/20.
//  Copyright © 2020 Ishan Alone. All rights reserved.
//

import UIKit
import Kingfisher



class ContactCell: UITableViewCell {

    @IBOutlet weak var nameLbl : UILabel!
    @IBOutlet weak var avatar : UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func setupModel(_ model : ContactList){
        self.nameLbl.text = model.name!
        let avatarSource = "https://api.adorable.io/avatars/285/" + (model.email_id ?? "0")
        if let url = URL(string: avatarSource){
            let processor = RoundCornerImageProcessor(cornerRadius: 20)
            avatar.kf.setImage(with: url, placeholder: nil, options: [.processor(processor)])
        }
        
    }
    

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
