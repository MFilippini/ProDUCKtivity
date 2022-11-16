//
//  ToDoViewController.swift
//  ProDUCKtivity
//
//  Created by Michael Filippini on 11/10/22.
//

import UIKit
import EventKit


class ToDoViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // used developer.apple.com as reference for the following code.
        
        let store = EKEventStore()
        
        store.requestAccess(to: .reminder) {granted, error in
            if let error = error {
                print("request access error: \(error)")
            }
            else if granted {
                print("access granted")
            }
            else {
                print("access denied")
            }
        }
        
        let predicate: NSPredicate? = store.predicateForReminders(in: nil)
        if let aPredicate = predicate {
            store.fetchReminders(matching: aPredicate, completion: {(_ reminders: [Any]?) -> Void in
                for remind: EKReminder? in reminders as? [EKReminder?] ?? [EKReminder?]() {
                    print(remind?.title)
                }
            })
        }
        // Do any additional setup after loading the view.
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
