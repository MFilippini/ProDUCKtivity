//
//  ToDoViewController.swift
//  ProDUCKtivity
//
//  Created by Michael Filippini on 11/10/22.
//

import UIKit
import EventKit


class ToDoViewController: UIViewController,UITableViewDataSource,UITableViewDelegate {

    struct Reminder {
        var title: String
    }
    @IBOutlet weak var tableView: UITableView!
    
    var theData:[Reminder] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // used developer.apple.com as reference for the following code.
        setupTableView()
        let store = EKEventStore()
        
        store.requestAccess(to: .reminder) {granted, error in
            if let error = error {
                print("request access error: \(error)")
            }
            else if granted {
                print("access granted")
                self.getReminders()
            }
            else {
                print("access denied")
            }
        }
    
        // Do any additional setup after loading the view.
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        getReminders()
    }
    
    func setupTableView() {
        tableView.dataSource = self
        tableView.delegate = self
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        
    }
    
    func getReminders() {
        
        let store = EKEventStore()
        
        let predicate: NSPredicate? = store.predicateForReminders(in: nil)
        if let aPredicate = predicate {
            store.fetchReminders(matching: aPredicate, completion: {(_ reminders: [Any]?) -> Void in
                self.theData = []
                for remind: EKReminder? in reminders as? [EKReminder?] ?? [EKReminder?]() {
                    let reminderStruct = Reminder(title: remind?.title ?? "")
                    self.theData.append(reminderStruct)
                }
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            })
        }
        
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return theData.count
    }
        
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: "cell")

        cell.textLabel!.text = theData[indexPath.row].title
        print(cell.textLabel!.text ?? "")
        return cell
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
