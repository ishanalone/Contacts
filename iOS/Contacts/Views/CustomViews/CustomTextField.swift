//
//  CustomTextField.swift
//  Contacts
//
//  Created by Sushant Alone on 16/08/20.
//  Copyright © 2020 Ishan Alone. All rights reserved.
//

import UIKit

class CustomTextField: UITextField {

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    private var border : CALayer?
    
    override func awakeFromNib() {
        
    }
    
    func setUnderLine(with color:UIColor? = .darkGray) {
        if let border = border{
            border.removeFromSuperlayer()
        }else{
            self.border = CALayer()
        }
        
        let width = CGFloat(0.5)
        border!.borderColor = color?.cgColor
        border!.frame = CGRect(x: 0, y: self.frame.size.height - width, width:  self.frame.size.width - 10, height: self.frame.size.height)
        border!.borderWidth = width
        self.layer.addSublayer(border!)
        self.layer.masksToBounds = true
    }
    
    func removeUnderLine() {
        if let border = border{
            border.removeFromSuperlayer()
        }
    }

}
