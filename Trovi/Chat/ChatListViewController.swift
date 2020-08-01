//
//  ChatListViewController.swift
//  FirebaseChat
//
//  Created by 송 종근 on 17/01/2020.
//  Copyright © 2020 송 종근. All rights reserved.
//

import UIKit
import FirebaseUI
import FirebaseFirestore
import FirebaseDatabase

class ChatListViewController:UIViewController,FUIAuthDelegate, UITableViewDataSource {
    
    
      var dbRef:DatabaseReference!
    private let db = Firestore.firestore()
    
    private var channelReference: CollectionReference {
      return db.collection("channels")
    }
    
    private var channels = [Channel]()
    private var channelListener: ListenerRegistration?
    
    @IBOutlet weak var tableView: UITableView!
    

    
    deinit {
      channelListener?.remove()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        channelListener = channelReference.addSnapshotListener { querySnapshot, error in
          guard let snapshot = querySnapshot else {
            print("Error listening for channel updates: \(error?.localizedDescription ?? "No error")")
            return
          }
          snapshot.documentChanges.forEach { change in
            self.handleDocumentChange(change)
          }
        }
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        Auth.auth().addStateDidChangeListener { (auth, user) in
            if let user = user {
                self.navigationItem.leftBarButtonItem?.title = "Logout"
                self.navigationItem.rightBarButtonItem?.isEnabled = true
            } else {
                self.navigationItem.leftBarButtonItem?.title = "Login"
                self.navigationItem.rightBarButtonItem?.isEnabled = false
            }
        }
    }
    
    @IBAction func doLogin(_ sender: Any) {
        if let current_user = Auth.auth().currentUser {
            NSLog("로그아웃")
            try! Auth.auth().signOut()
            self.navigationItem.leftBarButtonItem?.title = "Login"
            self.navigationItem.rightBarButtonItem?.isEnabled = false
        } else {
            let authUI = FUIAuth.defaultAuthUI()
            authUI!.delegate = self
            
            let providers: [FUIAuthProvider] = [
              FUIGoogleAuth(),
//              FUIFacebookAuth(),
//              FUIKakaoAuth()
            ]
            authUI!.providers = providers
            let authViewController = CustomAuthPickerView(authUI:  authUI!)

            let navc = UINavigationController(rootViewController: authViewController)

            //print(type(of: authViewController.view.subviews[0]))
            authViewController.modalPresentationStyle = .fullScreen
            self.present(navc, animated: true, completion: nil)
        }
    }
    
    @IBAction func AddChat(_ sender: Any) {
        let alertController = UIAlertController(title: "채팅방 만들기", message: "채팅방 이름을 입력하세요.", preferredStyle: .alert)
               
               let ok_action = UIAlertAction(title: "만들기", style: .default) { (action) in
                   guard let textField = alertController.textFields?[0] as? UITextField  else {return}
                   guard let chat_name = textField.text else {return}
                   self.createChat(chat_name)
               }
               
               let cancel_action = UIAlertAction(title: "취소", style: .cancel, handler: nil)
               alertController.addTextField()
               alertController.addAction(ok_action)
               alertController.addAction(cancel_action)
               
               present(alertController, animated: true, completion: nil)
    }
    
    
    func createChat(_ name:String) {
        let channel = Channel(name: name)
        var ref: DocumentReference? = nil
        ref = channelReference.addDocument(data: channel.representation) { error in
          if let e = error {
            print("Error saving channel: \(e.localizedDescription)")
          } //채널만들기가 끝났을 때
            print(ref?.documentID)
            self.dbRef = Database.database().reference()
            guard let userID = Auth.auth().currentUser?.uid else {return} //uid받아옴
            guard let chat_key = self.dbRef.child("chat/\(userID)/").childByAutoId().key else {return}
            self.dbRef.child(chat_key).setValue(ref?.documentID) { }
           
            
            //데이터베이스에 넣어준다 (user밑에)
        }
    }
    
    
    
    
    
    
    
    
    
    private func handleDocumentChange(_ change: DocumentChange) {
      guard let channel = Channel(document: change.document) else {
        return
      }
      
      switch change.type {
      case .added:
        addChannelToTable(channel)
        
      case .modified:
        updateChannelInTable(channel)
        
      case .removed:
        removeChannelFromTable(channel)
      }
    }
    
    private func addChannelToTable(_ channel: Channel) {
      guard !channels.contains(channel) else {
        return
      }
      
      channels.append(channel)
      channels.sort()
      
      guard let index = channels.index(of: channel) else {
        return
      }
      tableView.insertRows(at: [IndexPath(row: index, section: 0)], with: .automatic)
    }
    
    private func updateChannelInTable(_ channel: Channel) {
      guard let index = channels.index(of: channel) else {
        return
      }
      
      channels[index] = channel
      tableView.reloadRows(at: [IndexPath(row: index, section: 0)], with: .automatic)
    }
    
    private func removeChannelFromTable(_ channel: Channel) {
      guard let index = channels.index(of: channel) else {
        return
      }
      
      channels.remove(at: index)
      tableView.deleteRows(at: [IndexPath(row: index, section: 0)], with: .automatic)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return channels.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "chatCell", for: indexPath)
        
        cell.accessoryType = .disclosureIndicator
        cell.textLabel?.text = channels[indexPath.row].name
        cell.detailTextLabel?.text = "참여하기"
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let chatVC = segue.destination as? ChatViewController else {return}
        guard let indexPath = tableView.indexPathForSelectedRow else {return}
        chatVC.channel = channels[indexPath.row]
    }
}
