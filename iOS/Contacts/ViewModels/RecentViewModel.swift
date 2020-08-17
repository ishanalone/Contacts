//
//  RecentViewModel.swift
//  Contacts
//
//  Created by Sushant Alone on 17/08/20.
//  Copyright © 2020 Ishan Alone. All rights reserved.
//

import Foundation
import UIKit

class RecentViewModel {
    var data = Observable<[Contact]> (value : [])
    private var showToast : ((String) -> ())
    
    init(with toastHandler: @escaping ((String) -> ())) {
        self.showToast = toastHandler
    }
    
    func fetchContact() {
        if let result = Container.shared.fetchData(of: Contact.self, with: nil) as? [Contact]{
            data.value = result
        }
    }
    
    func setUpCell(_ cell : ContactCell, model : Contact){
        cell.setupManagedModel(model, onTap: { (str) in
            if let str = str {
                self.callNumber(phoneNumber: str)
                model.lastUsed = Date()
                Container.shared.save()
                self.fetchContact()
            }
        }) { (str) in
            self.copyToClipBoard(str)
        }
    }
    
    private func copyToClipBoard(_ text : String){
        if !text.isEmpty{
            let pasteboard = UIPasteboard.general
            pasteboard.string = text
            showToast("Text Copied")
        }
        
    }
    
    private func callNumber(phoneNumber: String) {
        guard let url = URL(string: "telprompt://\(phoneNumber)") else {return}
        if UIApplication.shared.canOpenURL(url){
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }else{
            showToast("Can't make calls from this device")
        }
    }
    
}
