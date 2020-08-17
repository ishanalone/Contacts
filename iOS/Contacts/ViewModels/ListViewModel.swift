//
//  ListViewModel.swift
//  Contacts
//
//  Created by Sushant Alone on 16/08/20.
//  Copyright © 2020 Ishan Alone. All rights reserved.
//

import Foundation

enum SortType : String {
    case name = "Name"
    case email = "Email"
    case lastUpdate = "Last update"
}

enum SortOrder {
    case ascending
    case descending
}


class ListViewModel {
    var data = Observable<[ContactList]> (value : [])
    var sortedData = Observable<[ContactList]> (value : [])
    var filteredContacts: [ContactList] = []
    
    var sortType : SortType = .name{
        didSet{
            self.sort()
        }
    }
    var sortOrder : SortOrder = .ascending {
        didSet{
            self.sort()
        }
    }
    private var sortTypes : [SortType] = [.name,.email,.lastUpdate]
    
    func getData() {
        APIClient.getContactList { (response) in
            switch response{
            case .success(let list):
                if let contacts = list.contactList {
                    self.data.value = contacts
                    self.sort()
                }
            case .failure(let error):
                print(error)
                self.sortedData.value = []
            }
        }
    }
    

    func sort()  {
        let arr = data.value.sorted { (contact1, contact2) -> Bool in
            if sortType == .name {
                if sortOrder == .ascending{
                    return contact1.name ?? "" < contact2.name ?? ""
                }else{
                    return contact1.name ?? "" > contact2.name ?? ""
                }
                
            }else if sortType == .email{
                if sortOrder == .ascending{
                    return contact1.email_id ?? "" < contact2.email_id ?? ""
                }else{
                    return contact1.email_id ?? "" > contact2.email_id ?? ""
                }
                
            }else{
                if sortOrder == .ascending{
                    return contact1.getUpdateDate()! < contact2.getUpdateDate()!
                }else{
                    return contact1.getUpdateDate()! > contact2.getUpdateDate()!
                }
            }
        }
        self.sortedData.value = arr
    }
    
    func getSortTypes() -> [SortType] {
        return sortTypes
    }
    
    func filterContentForSearchText(_ searchText: String) {
        filteredContacts = data.value.filter({ (item) -> Bool in
            return ((item.name?.lowercased().contains(searchText.lowercased()))! || (item.email_id?.lowercased().contains(searchText.lowercased()))!)
        })
      //tableView.reloadData()
    }
}
