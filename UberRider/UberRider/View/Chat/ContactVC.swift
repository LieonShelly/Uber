//
//  ContactVC.swift
//  UberRider
//
//  Created by lieon on 2017/3/31.
//  Copyright © 2017年 ChangHongCloudTechService. All rights reserved.
//

import UIKit

class ContactVC: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    fileprivate var contactVM: ContactViewModel = ContactViewModel()
    
    @IBAction func backAction(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func addAction(_ sender: Any) {
        addContact()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        loadData()
    }

}

extension ContactVC: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return contactVM.contacts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: ContactCell = tableView.dequeueReusableCell(for: indexPath)
        if indexPath.row <= contactVM.contacts.count - 1 {
            cell.textLabel?.text = contactVM.contacts[indexPath.row].name
        }
        return cell
    }
}

extension ContactVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let destVC: ChatVC  = UIStoryboard.findVC(storyboardName: StoryboardName.chat, identifier: ChatVC.identifier)
        if indexPath.row <= contactVM.contacts.count - 1 {
            destVC.tofriendID = contactVM.contacts[indexPath.row].id ?? ""
            destVC.tofriendName = contactVM.contacts[indexPath.row].name ?? ""
            navigationController?.pushViewController(destVC, animated: true)
        }
        
        
    }
}

extension ContactVC {
    fileprivate  func setupUI() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: CellID.contactCellID)
        tableView.register(UINib(nibName: NibName.contactCell, bundle: nil), forCellReuseIdentifier: ContactCell.identifier)
    }
    
    fileprivate  func loadData() {
        contactVM.getContacts {
            self.tableView.reloadData()
        }
    }
    
    fileprivate func addContact() {
        let alter = UIAlertController(title: "Add A Friend", message: nil, preferredStyle: .alert)
        alter.addTextField { textFied in
            textFied.placeholder = "Please enter a valid email"
        }
        let enterAction = UIAlertAction(title: "OK", style: .default) { (action) in
            if let textField =  alter.textFields?.first, let email = textField.text {
                self.contactVM.addConact(email: email, callback: { mesage in
                    self.show(title: "Add Info", message: mesage)
                })
            }
        }
        alter.addAction(enterAction)
        present(alter, animated: true, completion: nil)
    }
}
