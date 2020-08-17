//
//  Extensions.swift
//  
//
//  Created by Sushant Alone on 04/08/20.
//  Copyright © 2020 Ishan Alone. All rights reserved.
//


import Foundation
import UIKit


extension UIView {
    func makeViewCornerRadiusWithRadi(radius:CGFloat) {
        self.layer.cornerRadius = radius
        self.layer.masksToBounds = true
    }
    
    func dropShadow() {
        self.layer.shadowPath = UIBezierPath(rect: self.bounds).cgPath
        self.layer.shadowRadius = 3
        self.layer.shadowOffset = CGSize(width: 2.0, height: 2.0)
        self.layer.shadowOpacity = 0.5
    }
    
    func addBorder(withBorderColor color: UIColor, isTransparent: Bool) {
        self.layer.borderWidth = 1.0
        self.layer.borderColor = color.cgColor
        self.layer.cornerRadius = 5.0
        if isTransparent {
            self.backgroundColor = .clear
        }
    }
    
    func roundCorners(corners: UIRectCorner, radius: CGFloat) {
        let path = UIBezierPath(roundedRect: bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        layer.mask = mask
    }
    
    
}





extension UIView{
    func activityStartAnimating(activityColor: UIColor, backgroundColor: UIColor) {
        let backgroundView = UIView()
        backgroundView.frame = CGRect.init(x: 0, y: 0, width: self.bounds.width, height: self.bounds.height)
        backgroundView.backgroundColor = backgroundColor
        backgroundView.tag = activityBackgroundViewTag
        var activityIndicator: UIActivityIndicatorView = UIActivityIndicatorView()
        activityIndicator = UIActivityIndicatorView(frame: CGRect.init(x: 0, y: 0, width: 50, height: 50))
        activityIndicator.center = self.center
        activityIndicator.hidesWhenStopped = true
        activityIndicator.style = UIActivityIndicatorView.Style.large
        activityIndicator.color = activityColor
        activityIndicator.startAnimating()
        self.isUserInteractionEnabled = false
        
        backgroundView.addSubview(activityIndicator)
        
        self.addSubview(backgroundView)
    }
    
    func activityStopAnimating() {
        if let background = viewWithTag(activityBackgroundViewTag){
            background.removeFromSuperview()
        }
        self.isUserInteractionEnabled = true
    }
}

extension NSObject{
    public static func className() -> String {
        return String(describing: self)
    }
}

extension UITableViewCell {
    /// Generated cell identifier derived from class name
    public static func cellIdentifier() -> String {
        return String(describing: self)
    }
}

extension UICollectionViewCell {
    /// Generated cell identifier derived from class name
    public static func cellIdentifier() -> String {
        return String(describing: self)
    }
}

extension String {
   var isValidEmail: Bool {
      let regularExpressionForEmail = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
      let testEmail = NSPredicate(format:"SELF MATCHES %@", regularExpressionForEmail)
      return testEmail.evaluate(with: self)
   }
   var isValidPhone: Bool {
      do {
          let detector = try NSDataDetector(types: NSTextCheckingResult.CheckingType.phoneNumber.rawValue)
          let matches = detector.matches(in: self, options: [], range: NSMakeRange(0, self.count))
          if let res = matches.first {
              return res.resultType == .phoneNumber && res.range.location == 0 && res.range.length == self.count
          } else {
              return false
          }
      } catch {
          return false
      }
   }
}
