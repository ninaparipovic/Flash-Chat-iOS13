//
//  ChatViewController.swift
//  Flash Chat iOS13
//
//  Created by Angela Yu on 21/10/2019.
//  Copyright © 2019 Angela Yu. All rights reserved.
//

import UIKit
import Firebase

class ChatViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var messageTextfield: UITextField!
    
    let db = Firestore.firestore()
    
    var messages: [Message] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = K.appName
        tableView.dataSource = self
        navigationItem.hidesBackButton = true
        tableView.register(UINib(nibName: K.cellNibName, bundle: nil), forCellReuseIdentifier: K.cellIdentifier)
        
      
        loadMessages()
    }
    
    func loadMessages() {
        messages = []
        
        // closure below
        db.collection(K.FStore.collectionName)
            .order(by: K.FStore.dateField)
            .addSnapshotListener { (querySnapshot, err) in
            self.messages = []

            if let err = err {
                   print("Error getting documents: \(err)")
               } else {
                   for document in querySnapshot!.documents
                   {
                    if let sender = document.data()[K.FStore.senderField] as? String,
                       let body =  document.data()[K.FStore.bodyField] as? String {
                        print(sender)
                        let message = Message(sender: sender, body: body)
                        self.messages.append(message)
                        
                        DispatchQueue.main.async {
                            self.tableView.reloadData()
                            let indexPath = IndexPath(row: self.messages.count - 1, section: 0)
                            self.tableView.scrollToRow(at: indexPath, at: .top, animated: false)
                        }
                    }
                   }
               }
        }
    }
    
    
    
    @IBAction
    func sendPressed(_ sender: UIButton) {
        if let messageBody = messageTextfield.text, let messageSender = Auth.auth().currentUser?.email {
            db.collection(K.FStore.collectionName).addDocument(data: [
                K.FStore.senderField: messageSender,
                K.FStore.bodyField: messageBody,
                K.FStore.dateField: Date().timeIntervalSince1970
            ]) { (error) in
                if let e = error {
                    print("error with firestore \(e)")
                } else {
                    print("successs")
                }
                DispatchQueue.main.async {
                self.messageTextfield.text = ""
                  }
            }
        }
        
    }
    

    @IBAction func logOutPressed(_ sender: UIBarButtonItem) {
    do {
      try Auth.auth().signOut()
        navigationController?.popToRootViewController(animated: true)
        
    } catch let signOutError as NSError {
      print ("Error signing out: %@", signOutError)
    }
    }
}


extension ChatViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: K.cellIdentifier, for: indexPath) as! MessageCell
        let message = messages[indexPath.row]
        cell.label.text = message.body
        //This is a message from the current user.
               if message.sender == Auth.auth().currentUser?.email {
                   cell.youImage.isHidden = true
                cell.meImage.isHidden = false
                   cell.MessageBubble.backgroundColor = UIColor(named: K.BrandColors.lightPurple)
                   cell.label.textColor = UIColor(named: K.BrandColors.purple)
               }
               //This is a message from another sender.
               else {
                cell.meImage.isHidden = true
                cell.youImage.isHidden = false
                   cell.MessageBubble.backgroundColor = UIColor(named: K.BrandColors.purple)
                   cell.label.textColor = UIColor(named: K.BrandColors.lightPurple)
               }
        return cell
    }
}



