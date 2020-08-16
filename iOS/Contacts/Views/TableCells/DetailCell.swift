//
//  DetailCell.swift
//  Contacts
//
//  Created by Sushant Alone on 16/08/20.
//  Copyright © 2020 Ishan Alone. All rights reserved.
//

import UIKit


class DetailCell: UITableViewCell {

    @IBOutlet weak var textField : CustomTextField!
    var valueChange : ((String?, Bool) -> ())?
    var validate : ((String?) -> Bool)?
    var onTap : ((String?) -> ())?
    var onLongPress : ((String) -> ())?
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        textField.delegate = self
        textField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        setupGestures()
        // Initialization code
    }
    
    private func setupGestures() {
        let tapGesture = UITapGestureRecognizer.init(target: self, action: #selector(tappedOnView(_:)))
        let longPress = UILongPressGestureRecognizer.init(target: self, action: #selector(longPressOnView(_:)))
        self.addGestureRecognizer(tapGesture)
        self.addGestureRecognizer(longPress)
    }
    
    @objc private func tappedOnView(_ tapgesture: UITapGestureRecognizer){
        self.onTap?(textField.text)
    }
    
    @objc private func longPressOnView(_ tapgesture: UILongPressGestureRecognizer){
        self.onLongPress?(textField.text!)
    }
    
    func setupModel(_ value:String?, validate : ((String?) -> Bool)?, onChange : ((String?, Bool) -> ())?, decoration : ((CustomTextField) -> CustomTextField)? = nil) {
        self.validate = validate
        self.valueChange = onChange
        if let decoration = decoration{
            self.textField = decoration(textField)
        }
        self.textField.text = value
        self.textField.isUserInteractionEnabled = true
        textField.setUnderLine()
    }
    
    func setupModelForView(_ value:String?, onTap : ((String?) -> ())? = nil, onLongPress : ((String) -> ())? = nil, decoration : ((CustomTextField) -> CustomTextField)? = nil)  {
        self.textField.isUserInteractionEnabled = false
        if let decoration = decoration{
            self.textField = decoration(textField)
        }
        self.textField.text = value
        self.onTap = onTap
        self.onLongPress = onLongPress
        textField.removeUnderLine()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @objc func textFieldDidChange(_ textField: UITextField) {
        guard let tf = textField as? CustomTextField else {
            return
        }
        if validate?(tf.text) ?? true{
            tf.setUnderLine()
            self.valueChange?(textField.text, true)
        }else{
            tf.setUnderLine(with: .red)
            self.valueChange?(textField.text, false)
        }
    }

}

extension DetailCell : UITextFieldDelegate{
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    
    
}
