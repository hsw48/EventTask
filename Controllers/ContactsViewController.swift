//
//  ContactsViewController.swift
//  EventTask
//
//  Created by Harrison Woodward on 7/29/16.
//  Copyright © 2016 Harrison Woodward. All rights reserved.
//

import UIKit
import Contacts

class ContactsViewController: UIViewController, UISearchBarDelegate, UITableViewDataSource, UITableViewDelegate  {
        
    @IBOutlet weak var searchbar: UISearchBar!

    @IBOutlet weak var tableView: UITableView!
    
    var numbers = [String]()
    var names = [String]()
    
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
            
           // tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: kCellID)
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
            let contact = contacts[indexPath.row]
            
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
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "addNumber" {
            let indexPath = tableView.indexPathForSelectedRow!
            let contact = contacts[indexPath.row]
            var numberFormatted : String
            
            if contact.phoneNumbers.count > 1 {
                for phoneNumber: CNLabeledValue in contact.phoneNumbers {
                    if phoneNumber.label.containsString("Mobile") || phoneNumber.label.containsString("mobile"){
                        print("more than one")
                        let fullName = CNContactFormatter.stringFromContact(contact, style: .FullName)
                        names.append(fullName!)
                    
                        let number = phoneNumber.value as! CNPhoneNumber
            
                        numberFormatted = (String(number.stringValue.characters.filter({ !["-", "(", ")", " ", "+"].contains($0) })))
                        if numberFormatted.characters.count > 10 {
                            let index = numberFormatted.startIndex.advancedBy(0)
                            numberFormatted.removeAtIndex(index)
                        }
                
                        numbers.append(numberFormatted)
                    
                        let vc = segue.destinationViewController as! CreateGroupViewController
                
                        vc.names = names
                        vc.numbers = numbers
                        print("numbers \(vc.numbers)")
                    }
                }
            }else {
                print("only one")
                for phoneNumber: CNLabeledValue in contact.phoneNumbers {
                        let fullName = CNContactFormatter.stringFromContact(contact, style: .FullName)
                        names.append(fullName!)
                        
                        let number = phoneNumber.value as! CNPhoneNumber
                        
                        numberFormatted = (String(number.stringValue.characters.filter({ !["-", "(", ")", " ", "+"].contains($0) })))
                        if numberFormatted.characters.count > 10 {
                            let index = numberFormatted.startIndex.advancedBy(0)
                            numberFormatted.removeAtIndex(index)
                        }
                        
                        numbers.append(numberFormatted)
                        
                        let vc = segue.destinationViewController as! CreateGroupViewController
                        
                        vc.names = names
                        vc.numbers = numbers
                     print("numbers \(vc.numbers)")
                }
            }
        }
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


