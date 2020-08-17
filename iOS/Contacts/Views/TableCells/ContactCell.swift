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
    
    private var onTap : ((String?) -> ())?
    private var onLongPress : ((String) -> ())?
    
    private var contact : Contact?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    private func setupGestures() {
        let tapGesture = UITapGestureRecognizer.init(target: self, action: #selector(tappedOnView(_:)))
        let longPress = UILongPressGestureRecognizer.init(target: self, action: #selector(longPressOnView(_:)))
        self.addGestureRecognizer(tapGesture)
        self.addGestureRecognizer(longPress)
    }
    
    @objc private func tappedOnView(_ tapgesture: UITapGestureRecognizer){
        if let model = contact{
            let phn = (model.countryCode ?? "+91")+"\(model.phoneNumber ?? "")"
            self.onTap?(phn)
        }
        
    }
    
    @objc private func longPressOnView(_ tapgesture: UILongPressGestureRecognizer){
        if let model = contact{
            let phn = (model.countryCode ?? "+91")+"\(model.phoneNumber ?? "")"
            self.onLongPress?(phn)
        }
        
    }
    
    func setupModel(_ model : ContactList){
        self.nameLbl.text = model.name!
        let avatarSource = "https://api.adorable.io/avatars/285/" + (model.email_id ?? "0")
        if let url = URL(string: avatarSource){
            let processor = RoundCornerImageProcessor(cornerRadius: 20)
            avatar.kf.setImage(with: url, placeholder: nil, options: [.processor(processor)])
        }
        
    }
    
    func setupManagedModel(_ model : Contact, onTap : ((String?) -> ())? = nil, onLongPress : ((String) -> ())? = nil) {
        self.nameLbl.text = model.name!
        self.contact = model
        self.onTap = onTap
        self.onLongPress = onLongPress
        let avatarSource = "https://api.adorable.io/avatars/285/" + (model.email ?? "0")
        if let url = URL(string: avatarSource){
            let processor = RoundCornerImageProcessor(cornerRadius: 20)
            avatar.kf.setImage(with: url, placeholder: nil, options: [.processor(processor)])
        }
        setupGestures()
    }
    
    

    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
