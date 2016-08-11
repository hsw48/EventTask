//
//  AddMembersViewController.swift
//  iWill
//
//  Created by Harrison Woodward on 8/3/16.
//  Copyright © 2016 Harrison Woodward. All rights reserved.
//

import UIKit
import Contacts
import Firebase
import FirebaseDatabase

class AddMembersViewController: UIViewController, UISearchBarDelegate, UITableViewDataSource, UITableViewDelegate {

        @IBOutlet weak var tableView: UITableView!
    
        let searchController = UISearchController(searchResultsController: nil)
        var filteredContacts = [CNContact]()
        var groupId : String = ""
        
        private var contacts = [CNContact]()
        private var authStatus: CNAuthorizationStatus = .Denied {
            didSet { // switch enabled search bar, depending contacts permission
                //           searchBar.userInteractionEnabled = authStatus == .Authorized
                
                if authStatus == .Authorized { // all search
                    contacts = fetchContacts("")
                    tableView.reloadData()
                }
            }
        }
        
        private let kCellID = "ContactsCell"
        
        override func viewDidLoad() {
            super.viewDidLoad()
            
            checkAuthorization()
            
            searchController.searchResultsUpdater = self
            searchController.dimsBackgroundDuringPresentation = false
            definesPresentationContext = true
            tableView.tableHeaderView = searchController.searchBar
            self.tableView.contentInset = UIEdgeInsetsMake(25, 0, 0, 0)
       
        }
    func filterContentForSearchText(searchText: String, scope: String = "All") {
        filteredContacts = contacts.filter { contact in
            let fullName = CNContactFormatter.stringFromContact(contact, style: .FullName) ?? "NO NAME"
            return fullName.lowercaseString.containsString(searchText.lowercaseString)
        }
        
        tableView.reloadData()
    }
        
        override func didReceiveMemoryWarning() {
            super.didReceiveMemoryWarning()
        }
        
        func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
            contacts = fetchContacts(searchText)
            tableView.reloadData()
        }
        
        func numberOfSectionsInTableView(tableView: UITableView) -> Int {
            return 1
        }
        
        func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return contacts.count
        }
        
        func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
            let cell = tableView.dequeueReusableCellWithIdentifier(kCellID, forIndexPath: indexPath)
            var contact = CNContact()
            
            if searchController.active && searchController.searchBar.text != "" {
                self.tableView.contentInset = UIEdgeInsetsMake(25, 0, 0, 0)
                if filteredContacts.count == 0 {
                    print("empty")
                } else {
                    contact = filteredContacts[indexPath.row] }
            } else {
                contact = contacts[indexPath.row]
            }
            
            // get the full name
            let fullName = CNContactFormatter.stringFromContact(contact, style: .FullName) ?? "NO NAME"
            cell.textLabel?.text = fullName
            
            for phoneNumber: CNLabeledValue in contact.phoneNumbers {
                
                let number  = phoneNumber.value as! CNPhoneNumber
                
                let numberFormatted = (String(number.stringValue.characters.filter({ !["-", "(", ")", " ", "+"].contains($0) })))
                
                let lable :String  =  CNLabeledValue.localizedStringForLabel(phoneNumber.label )
                print("\(lable)  \(numberFormatted)")
                
            }
            return cell
        }
        
    
        
        
        func tableView(tableView: UITableView, editActionsForRowAtIndexPath indexPath: NSIndexPath) -> [UITableViewRowAction]? {
            let deleteActionHandler = { (action: UITableViewRowAction, index: NSIndexPath) in
                let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: { [unowned self] (action: UIAlertAction) in
                    // set the data to be deleted
                    let request = CNSaveRequest()
                    let contact = self.contacts[index.row].mutableCopy() as! CNMutableContact
                    request.deleteContact(contact)
                    
                    do {
                        // save
                        let fullName = CNContactFormatter.stringFromContact(contact, style: .FullName) ?? "NO NAME"
                        let store = CNContactStore()
                        try store.executeSaveRequest(request)
                        print("\(fullName) Deleted")
                        
                        // update table
                        self.contacts.removeAtIndex(index.row)
                        dispatch_async(dispatch_get_main_queue(), {
                            self.tableView.deleteRowsAtIndexPaths([index], withRowAnimation: .Fade)
                        })
                    } catch let error as NSError {
                        print("Delete error \(error.localizedDescription)")
                    }
                    })
                
                let cancelAction = UIAlertAction(title: "CANCEL", style: UIAlertActionStyle.Default, handler: { [unowned self] (action: UIAlertAction) in
                    self.tableView.editing = false
                    })
                
                // show alert
                self.showAlert(title: "Delete Contact", message: "OK？", actions: [okAction, cancelAction])
            }
            
            return [UITableViewRowAction(style: .Destructive, title: "Delete", handler: deleteActionHandler)]
                }
            
            
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "addNumber" {
            let indexPath = tableView.indexPathForSelectedRow!
        
            let contact : CNContact
            if searchController.active && searchController.searchBar.text != "" {
                contact = filteredContacts[indexPath.row]
            } else {
                contact = contacts[indexPath.row]
            }
            
            
            var numberFormatted : String
            
            if contact.phoneNumbers.count > 1 {
                for phoneNumber: CNLabeledValue in contact.phoneNumbers {
                    if phoneNumber.label.containsString("Mobile") || phoneNumber.label.containsString("mobile"){
                        print("more than one")
 
                        let number = phoneNumber.value as! CNPhoneNumber
                        
                        numberFormatted = (String(number.stringValue.characters.filter({ !["-", "(", ")", " ", "+"].contains($0) })))
                        if numberFormatted.characters.count > 10 {
                            let index = numberFormatted.startIndex.advancedBy(0)
                            numberFormatted.removeAtIndex(index)
                        }
                        let ref = FIRDatabase.database().reference()
                        
                        // check if phone number is in database: snapshot.value = phone number's userId
                        ref.child("Phone Numbers").child(numberFormatted).observeEventType(.Value, withBlock: { snapshot in
                            let newGroup : NSDictionary = [self.groupId : "https://eventtask-40794.firebaseio.com/Groups/\(self.groupId)"]
                            
                            if snapshot.value! is String {
                                print("adding number")
                                let newUserId = snapshot.value as! String
                                ref.child("Users").child(newUserId).child("groups").updateChildValues(newGroup as! [NSObject : AnyObject])
                                
                              
                            }
                            
                        })
                     searchController.searchBar.text = ""
                    }}}else {
                print("only one")
                for phoneNumber: CNLabeledValue in contact.phoneNumbers {
                    
                    let number = phoneNumber.value as! CNPhoneNumber
                    
                    numberFormatted = (String(number.stringValue.characters.filter({ !["-", "(", ")", " ", "+"].contains($0) })))
                    if numberFormatted.characters.count > 10 {
                        let index = numberFormatted.startIndex.advancedBy(0)
                        numberFormatted.removeAtIndex(index)
                    }
                    let ref = FIRDatabase.database().reference()
                    
                    // check if phone number is in database: snapshot.value = phone number's userId
                    ref.child("Phone Numbers").child(numberFormatted).observeEventType(.Value, withBlock: { snapshot in
                        let newGroup : NSDictionary = [self.groupId : "https://eventtask-40794.firebaseio.com/Groups/\(self.groupId)"]
                        
                        if snapshot.value! is String {
                            print("adding number")
                            let newUserId = snapshot.value as! String
                            ref.child("Users").child(newUserId).child("groups").updateChildValues(newGroup as! [NSObject : AnyObject])
                            let userName = ref.child("Users").child(newUserId).child("name")
                            userName.observeEventType(.Value, withBlock: { snapshot in
                                let newUserName = snapshot.value as! String
                                var userIds = [String]()
                                let userIdsRef = ref.child("Groups").child(self.groupId).child("userIds")
                                userIdsRef.observeSingleEventOfType(.Value, withBlock: { snapshot in
                                    let snapshots = snapshot.children.allObjects as! [FIRDataSnapshot]
                                    for snap in snapshots {
                                        userIds.append(String(snap.value!))
                                        print("userIds \(userIds)")
                                    }
                                    userIds.append(newUserId)
                                     print("userIds final \(userIds)")
                                    userIdsRef.setValue(userIds)
                                })

                             let userNamesRef = ref.child("Groups").child(self.groupId).child("userNames")
                             var userNames = [String]()
                            userNamesRef.observeSingleEventOfType(.Value, withBlock: { snapshot in
                                let snapshots = snapshot.children.allObjects as! [FIRDataSnapshot]
                                for snap in snapshots {
                                    userNames.append(String(snap.value!))
                                }
                                userNames.append(newUserName)
                                userNamesRef.setValue(userNames)
                                
                            })
                           
                        })
                        }})
                    
                }
            }
        }
    }
            
        private func checkAuthorization() {
            // get current status
            let status = CNContactStore.authorizationStatusForEntityType(.Contacts)
            authStatus = status
            
            switch status {
            case .NotDetermined: // case of first access
                CNContactStore().requestAccessForEntityType(.Contacts) { [unowned self] (granted, error) in
                    if granted {
                        print("Permission allowed")
                        self.authStatus = .Authorized
                    } else {
                        print("Permission denied")
                        self.authStatus = .Denied
                    }
                }
            case .Restricted, .Denied:
                print("Unauthorized")
                
                let okAction = UIAlertAction(title: "OK", style: .Default, handler: nil)
                let settingsAction = UIAlertAction(title: "Settings", style: .Default, handler: { (action: UIAlertAction) in
                    let url = NSURL(string: UIApplicationOpenSettingsURLString)
                    UIApplication.sharedApplication().openURL(url!)
                })
                showAlert(
                    title: "Permission Denied",
                    message: "You have not permission to access contacts. Please allow the access the Settings screen.",
                    actions: [okAction, settingsAction])
            case .Authorized:
                print("Authorized")
            }
        }
        
        
        // fetch the contact of matching names
        private func fetchContacts(name: String) -> [CNContact] {
            let store = CNContactStore()
            
            
            do {
                let request = CNContactFetchRequest(keysToFetch: [CNContactFormatter.descriptorForRequiredKeysForStyle(.FullName), CNContactPhoneNumbersKey])
                if name.isEmpty { // all search
                    request.predicate = nil
                } else {
                    request.predicate = CNContact.predicateForContactsMatchingName(name)
                }
                
                var contacts = [CNContact]()
                try store.enumerateContactsWithFetchRequest(request, usingBlock: { (contact, error) in
                    contacts.append(contact)
                })
                
                return contacts
            } catch let error as NSError {
                print("Fetch error \(error.localizedDescription)")
                return []
            }
        }
        
        private func showAlert(title title: String, message: String, actions: [UIAlertAction]) {
            let alert = UIAlertController(title: title, message: message, preferredStyle: .Alert)
            
            for action in actions {
                alert.addAction(action)
            }
            
            dispatch_async(dispatch_get_main_queue(), { [unowned self] () in
                self.presentViewController(alert, animated: true, completion: nil)
                })
        }
    }

extension AddMembersViewController: UISearchResultsUpdating {
    func updateSearchResultsForSearchController(searchController: UISearchController) {
        filterContentForSearchText(searchController.searchBar.text!)
    }
}



