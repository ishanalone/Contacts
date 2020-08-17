//
//  DetailViewModel.swift
//  Contacts
//
//  Created by Sushant Alone on 16/08/20.
//  Copyright © 2020 Ishan Alone. All rights reserved.
//

import Foundation
import UIKit
import CountryPickerView
import CoreData

enum RowType : String {
    case name = "Name"
    case email = "Email"
    case phone = "Phone number"
}

enum ViewMode {
    case viewOnly
    case edit
    case add
}

protocol MailComposerDelegate {
    func sendMail(_ to : String)
}

class DetailViewModel {
    private var contact : ContactList
    private var sectionArray : [RowType] = [.name, .email, .phone]
    private var delegate : MailComposerDelegate?
    private var showToast : ((String) -> ())?
    
    var viewMode : ViewMode = .viewOnly
    let cp = CountryPickerView(frame: CGRect(x: 0, y: 0, width: 120, height: 20))
    
    init(with contact : ContactList, delegate : MailComposerDelegate, showToast : ((String) -> ())? = nil) {
        self.contact = contact
        self.delegate = delegate
        self.showToast = showToast
    }
    
    
    
    func numberOfSections() -> Int {
        return sectionArray.count
    }
    
    func rowType(for section:Int) -> RowType {
        return sectionArray[section]
    }
    
    func setupCell(_ cell : DetailCell, for type : RowType) {
        if viewMode == .viewOnly{
            self.setUpCellForView(cell, for: type)
        }else{
            self.setupCellForEdit(cell, for: type)
        }
    }
    
    private func setUpCellForView(_ cell : DetailCell, for type : RowType)  {
        var value : String?
        var onTap : ((String?) -> ())?
        var onLongPress : ((String?) -> ())?
        var decoration : ((CustomTextField)->CustomTextField)?
        switch type {
        case .phone:
            value = contact.phone_number
            onTap = { (number) in
                let phn = (self.contact.country_code ?? "+91")+"\(number ?? "")"
                self.callNumber(phoneNumber: phn)
            }
            onLongPress = { (number) in
                self.copyToClipBoard(number ?? "")
            }
            decoration = { (textfield) in
                self.cp.setCountryByPhoneCode(self.contact.country_code ?? "+91")
                self.cp.font = UIFont.systemFont(ofSize: 20)
                textfield.leftView = self.cp
                textfield.leftViewMode = .always
                return textfield
            }
        case .email:
            value = contact.email_id
            onTap = { (email) in
                self.sendMail(email ?? "")
            }
            onLongPress = { (email) in
                self.copyToClipBoard(email ?? "")
            }
        case .name:
            value = contact.name
            onLongPress = { (name) in
                self.copyToClipBoard(name ?? "")
            }
        }
        cell.setupModelForView(value, onTap: onTap, onLongPress: onLongPress, decoration: decoration)
        
    }
    
    private func copyToClipBoard(_ text : String){
        if !text.isEmpty{
            let pasteboard = UIPasteboard.general
            pasteboard.string = text
            if let showToast = showToast{
                showToast("Copied")
            }
        }
        
    }
    
    private func callNumber(phoneNumber: String) {
        guard let url = URL(string: "telprompt://\(phoneNumber)") else {return}
        if UIApplication.shared.canOpenURL(url){
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }else{
            if let showToast = showToast{
                showToast("Can's call from this device")
            }
        }
        
        writeToCD(self.contact)
    }
    
    private func sendMail(_ to:String){
        self.delegate?.sendMail(to)
    }
    
    
    private func setupCellForEdit(_ cell : DetailCell, for type : RowType)  {
        var value : String?
        var validate : ((String?) -> Bool)?
        var onChange : ((String?, Bool) -> ())?
        var decoration : ((CustomTextField)->CustomTextField)?
        switch type {
        case .name:
            value = contact.name
            validate = {(runningStr) -> Bool in
                return self.validateName(runningStr)
            }
            onChange = {(str, isValid) in
                if isValid{
                    self.contact.name = str
                }
            }
            decoration = { (textfield) in
                textfield.keyboardType = .default
                return textfield
            }
        case .email:
            value = contact.email_id
            validate = {(runningStr) -> Bool in
                return self.validateEmail(runningStr)
            }
            onChange = {(str, isValid) in
                if isValid{
                    self.contact.email_id = str
                }
            }
            decoration = { (textfield) in
                textfield.keyboardType = .emailAddress
                return textfield
            }
        case .phone:
            value = contact.phone_number
            validate = {(runningStr) -> Bool in
                return self.validatePhnNumber(runningStr)
            }
            onChange = {(str, isValid) in
                if isValid{
                    self.contact.phone_number = str
                }
            }
            decoration = { (textfield) in
                self.cp.setCountryByCode(self.contact.country_code ?? "+91")
                self.cp.font = UIFont.systemFont(ofSize: 20)
                textfield.leftView = self.cp
                textfield.leftViewMode = .always
                textfield.keyboardType = .phonePad
                return textfield
            }
        }
        cell.setupModel(value, validate: validate, onChange: onChange, decoration: decoration)
    }
    
    func validateName(_ str:String?) -> Bool {
        return true
    }
    
    func validateEmail(_ str:String?) -> Bool {
        return str?.isValidEmail ?? false
    }
    
    func validatePhnNumber(_ str:String?) -> Bool {
        return str?.isValidPhone ?? false
    }
}

extension DetailViewModel {
    
    func addContact(_ completionHandler : @escaping ((Bool)->())){
        self.contact.country_code = cp.selectedCountry.phoneCode
        APIClient.addContact(self.contact) { (response) in
            switch response{
            case .success(let model):
                if model.code == 200 {
                    completionHandler(true)
                }
            case .failure(let error):
                print(error)
                completionHandler(false)
            }
        }
    }
    
    func updateContact(_ completionHandler : @escaping ((Bool)->())){
        self.contact.country_code = cp.selectedCountry.phoneCode
        APIClient.updateContact(self.contact) { (response) in
            switch response{
            case .success(let model):
                if model.code == 200 {
                    completionHandler(true)
                }
            case .failure(let error):
                print(error)
                completionHandler(false)
            }
        }
    }
}

extension DetailViewModel {
   
    func writeToCD(_ contactModel:ContactList) {
        let predicate = NSPredicate(format: "id == %@", contactModel.id!)
        var contact : Contact?
        if let tempContact = Container.shared.fetchData(of: Contact.self, with: predicate){
            if tempContact.count > 0{
                contact = (tempContact[0] as! Contact)
                contact = contactModel.managedObject(contact!)
                contact!.lastUsed = Date()
            }else{
                contact = contactModel.managedObject()
                contact!.lastUsed = Date()
            }
        }else{
            contact = contactModel.managedObject()
        }
        Container.shared.save()
    }
}
