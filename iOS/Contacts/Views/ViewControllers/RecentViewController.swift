//
//  RecentViewController.swift
//  Contacts
//
//  Created by Sushant Alone on 17/08/20.
//  Copyright © 2020 Ishan Alone. All rights reserved.
//

import UIKit

class RecentViewController: UIViewController {

    @IBOutlet weak var listTable : UITableView!
    var model : RecentViewModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.listTable.dataSource = self
        self.listTable.delegate = self
        model = RecentViewModel(with: { (message) in
            self.showToast(with: message)
        })
        self.bindData()
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if let model = model{
            model.fetchContact()
        }
        
    }
    
    func showToast(with message:String)  {
        self.view.makeToast(message, duration: 3.0, position: .bottom)
    }
    
    func bindData()  {
        if let model = model{
            model.data.addObserver(fireNow: false) { (itemVM) in
                DispatchQueue.main.async {
                    self.listTable.reloadData()
                }
            }
        }
        
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

extension RecentViewController : UITableViewDataSource{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return model?.data.value.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell : ContactCell  = tableView.dequeueReusableCell(withIdentifier: ContactCell.className(), for: indexPath) as! ContactCell
        if let model = model{
            let item = model.data.value[indexPath.row]
            model.setUpCell(cell, model: item)
        }
        
        return cell
    }
    
    
}

extension RecentViewController : UITableViewDelegate{
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
}
