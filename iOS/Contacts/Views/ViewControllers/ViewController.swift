//
//  ViewController.swift
//  Contacts
//
//  Created by Sushant Alone on 15/08/20.
//  Copyright © 2020 Ishan Alone. All rights reserved.
//

import UIKit
import SnapKit
class ViewController: UIViewController {

    
    @IBOutlet weak var listTable : UITableView!
    var model = ListViewModel()
    @IBOutlet weak var sortOrderButton : UIButton!
    @IBOutlet weak var sortTypeButton : UIButton!
    var picker = UIPickerView(frame: .zero)
    let searchController = UISearchController(searchResultsController: nil)
    var isSearchBarEmpty: Bool {
      return searchController.searchBar.text?.isEmpty ?? true
    }
    var isFiltering: Bool {
      return searchController.isActive && !isSearchBarEmpty
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.listTable.dataSource = self
        self.listTable.delegate = self
        self.bindData()
        self.view.activityStartAnimating(activityColor: .black, backgroundColor: .lightGray)
        model.getData()
        setupPicker()
        setupSearchController()
        // Do any additional setup after loading the view.
    }
    
    func setupPicker()  {
        picker.backgroundColor = .white
        picker.delegate = self
        picker.dataSource = self
        picker.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(picker)
        picker.snp.makeConstraints { (make) in
            make.leading.trailing.bottom.equalToSuperview()
            make.height.equalTo(0)
        }
    }
    
    func setupSearchController() {
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search Contacts"
        navigationItem.searchController = searchController
        definesPresentationContext = true
    }
    
    func showPicker() {
        picker.snp.remakeConstraints { (make) in
            make.leading.trailing.bottom.equalToSuperview()
        }
    }
    
    func hidePicker() {
        picker.snp.remakeConstraints { (make) in
            make.leading.trailing.bottom.equalToSuperview()
            make.height.equalTo(0)
        }
    }
    
    func bindData()  {
        model.sortedData.addObserver(fireNow: false) { (itemVM) in
            DispatchQueue.main.async {
                self.view.activityStopAnimating()
                self.listTable.reloadData()
            }
        }
    }
    
    @IBAction func barButtonClicked(_ sender: Any) {
        self.performSegue(withIdentifier: "Detail", sender: nil)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "Detail"{
            let destination = segue.destination as! UINavigationController
            destination.isModalInPresentation = true
            if let detailVC = destination.viewControllers.first as? DetailViewController{
                if let contact = sender as? ContactList{
                    detailVC.contact = contact
                }
                
                let onDismiss = {
                    self.model.getData()
                }
                detailVC.afterDismiss = onDismiss
            }
        }
    }
    
    @IBAction func sortOrderClicked(_ sender: Any) {
        if model.sortOrder == .ascending{
            sortOrderButton.setImage(UIImage(named: "ascending"), for: .normal)
            model.sortOrder = .descending
        }else{
            sortOrderButton.setImage(UIImage(named: "descending"), for: .normal)
            model.sortOrder = .ascending
        }
    }
    
    
    @IBAction func sortTypeClicked(_ sender: Any) {
        self.showPicker()
        let index = model.getSortTypes().firstIndex(of: model.sortType)
        picker.selectRow(index ?? 0, inComponent: 0, animated: true)
    }
}

extension ViewController : UITableViewDataSource{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isFiltering {
            return model.filteredContacts.count
        }
        return model.sortedData.value.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell : ContactCell  = tableView.dequeueReusableCell(withIdentifier: ContactCell.className(), for: indexPath) as! ContactCell
        if isFiltering {
            let item = model.filteredContacts[indexPath.row]
            cell.setupModel(item)
        }else{
            let item = model.sortedData.value[indexPath.row]
            cell.setupModel(item)
        }
        
        
        return cell
    }
    
    
}

extension ViewController : UITableViewDelegate{
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if isFiltering {
            let item = model.filteredContacts[indexPath.row]
            self.performSegue(withIdentifier: "Detail", sender: item)
        }else{
            let item = model.sortedData.value[indexPath.row]
            self.performSegue(withIdentifier: "Detail", sender: item)
        }
        
        
    }
}

extension ViewController : UIPickerViewDataSource{
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return model.getSortTypes().count
    }
    
    
}

extension ViewController : UIPickerViewDelegate{
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return model.getSortTypes()[row].rawValue
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        let type = model.getSortTypes()[row]
        model.sortType = type
        sortTypeButton.setTitle(type.rawValue, for: .normal)
        self.hidePicker()
    }
}

extension ViewController : UISearchResultsUpdating{
    func updateSearchResults(for searchController: UISearchController) {
        let searchBar = searchController.searchBar
        model.filterContentForSearchText(searchBar.text!)
        self.listTable.reloadData()
    }
    
    
}
