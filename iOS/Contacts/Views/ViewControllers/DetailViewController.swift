//
//  DetailViewController.swift
//  Contacts
//
//  Created by Sushant Alone on 16/08/20.
//  Copyright © 2020 Ishan Alone. All rights reserved.
//

import UIKit
import MessageUI

class DetailViewController: UIViewController {

    var viewModel : DetailViewModel?
    var contact : ContactList?
    var afterDismiss : (()->())?
    @IBOutlet weak var detailTable : UITableView!
    @IBOutlet weak var barButton : UIBarButtonItem!
    @IBOutlet weak var cancelButton : UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        detailTable.delegate = self
        detailTable.dataSource = self
        
        if let contact = contact{
            viewModel = DetailViewModel(with: contact, delegate: self)
            barButton.title = "Edit"
        }else{
            contact = ContactList()
            viewModel = DetailViewModel(with: contact!, delegate: self)
            viewModel?.viewMode = .add
            barButton.title = "Save"
        }
        
        // Do any additional setup after loading the view.
    }
    
    @IBAction func barButtonClicked(_ sender: Any) {
        if let viewModel = viewModel{
            switch viewModel.viewMode {
            case .viewOnly:
                viewModel.viewMode = .edit
                barButton.title = "Save"
                self.detailTable.reloadData()
            case .edit:
                self.view.activityStartAnimating(activityColor: Constants.activityBackgroundColor, backgroundColor: .lightGray)
                viewModel.updateContact { (success) in
                    if success{
                        // Toast
                    }else {
                        // Toast
                    }
                    self.view.activityStopAnimating()
                    viewModel.viewMode = .viewOnly
                    self.barButton.title = "Edit"
                    self.detailTable.reloadData()
                }
            case .add:
                self.view.activityStartAnimating(activityColor: Constants.activityBackgroundColor, backgroundColor: .lightGray)
                viewModel.addContact { (success) in
                    if success{
                        // Toast
                    }else {
                        // Toast
                    }
                    self.view.activityStopAnimating()
                    self.dismiss(animated: true) {
                        if let afterDismiss = self.afterDismiss{
                            afterDismiss()
                        }
                    }
                }
        
            }
            
        }
    }
    
    @IBAction func cancelButtonClicked(_ sender: Any) {
        if let viewModel = viewModel{
            switch viewModel.viewMode {
            case .viewOnly:
                self.dismiss(animated: true) {
                    if let afterDismiss = self.afterDismiss{
                        afterDismiss()
                    }
                }
            case .edit:
                viewModel.viewMode = .viewOnly
                self.barButton.title = "Edit"
                self.detailTable.reloadData()
            case .add:
                self.dismiss(animated: true, completion: nil)
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

extension DetailViewController : MFMailComposeViewControllerDelegate, MailComposerDelegate{
    func sendMail(_ to: String) {
        if MFMailComposeViewController.canSendMail() {
            let mail = MFMailComposeViewController()
            mail.mailComposeDelegate = self
            mail.setToRecipients([to])
            present(mail, animated: true)
        } else {
            // show failure alert
        }
    }
    
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true)
    }
}

extension DetailViewController : UITableViewDataSource{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        guard let viewModel = viewModel else {
            return 0
        }
        return viewModel.numberOfSections()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell : DetailCell = tableView.dequeueReusableCell(withIdentifier: DetailCell.className(), for: indexPath) as! DetailCell
        if let viewModel = viewModel{
            let type = viewModel.rowType(for: indexPath.section)
            viewModel.setupCell(cell, for: type)
        }
        return cell
    }
    
    
}

extension DetailViewController : UITableViewDelegate{
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: tableView.frame.size.width, height: 20))
        label.font = UIFont.systemFont(ofSize: 17)
        if let viewModel = viewModel{
            let type : RowType = viewModel.rowType(for: section)
            label.text = "  "+type.rawValue+":"
        }
        //label.backgroundColor = .lightGray
        return label
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 20
    }
}
