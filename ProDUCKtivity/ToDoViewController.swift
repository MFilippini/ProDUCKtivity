//
//  ToDoViewController.swift
//  ProDUCKtivity
//
//  Created by Michael Filippini on 11/10/22.
//

import UIKit
import EventKit

struct Reminder {
    var title: String
    var id: String
    var isCompleted: Bool = false
    var notes: String? = nil
}

class ReminderDoneButton: UIButton {
    var id: String?
}

class ToDoViewController: UIViewController,UITableViewDataSource,UITableViewDelegate {

    
    
    enum Errors :LocalizedError {
        case accessDenied
        case failedFetch
        case failedReadItem
        
        var errorDescription: String? {
            switch self {
            case.accessDenied:
                return NSLocalizedString("This app does not have permission to read reminders.", comment: "access denied error")
            case.failedFetch:
                return NSLocalizedString("Failed to fetch reminders.", comment: "fetch fail error")
            case.failedReadItem:
                return NSLocalizedString("Failed to read a reminder item.", comment: "read item fail")
            }
        }
    }
    @IBOutlet weak var tableView: UITableView!
    
    private let store = EKEventStore();
    
    var accessGranted = EKEventStore.authorizationStatus(for: .reminder) == .authorized
    
    var theData:[Reminder] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // used developer.apple.com as reference for the following code.
        setupTableView()
        
        store.requestAccess(to: .reminder) {granted, error in
            if let error = error {
                print("request access error: \(error)")
            }
            else if granted {
                print("access granted")
                self.accessGranted = true
                NotificationCenter.default.addObserver(self, selector: #selector(self.eventStoreChanged(_:)), name: .EKEventStoreChanged, object: nil)
                do {
                    try self.getReminders()
                } catch Errors.accessDenied {
                    self.showError(Errors.accessDenied)
                } catch {
                    self.showError(error)
                }
            }
            else {
                self.accessGranted = false
                print("access denied")
            }
        }
    
        // Do any additional setup after loading the view.
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    
    func showError(_ error: Error) {
        let alert = UIAlertController(title:"", message: error.localizedDescription, preferredStyle: .alert )
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { [weak self] _ in
            self?.dismiss(animated: true)
        }))
        present(alert, animated: true, completion: nil)
    }
    
    func setupTableView() {
        tableView.dataSource = self
        tableView.delegate = self
//        tableView.Appearance.
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        
    }
    private func doneButtonConfiguration(for reminder: Reminder) -> ReminderDoneButton {
        let symbolName = reminder.isCompleted ? "circle.fill" : "circle"
        let symbolConfiguration = UIImage.SymbolConfiguration(textStyle: .title1)
        let image = UIImage(systemName: symbolName, withConfiguration: symbolConfiguration)
        let button = ReminderDoneButton()
        button.addTarget(self, action: #selector(didPressDoneButton(_:)), for: .touchUpInside)
        button.id = reminder.id
        button.setImage(image, for: .normal)
        return button
    }
    
    
    func getReminders() throws  {
        guard accessGranted else {
            throw Errors.accessDenied
        }
        
        let predicate: NSPredicate? = store.predicateForReminders(in: nil)
        if let aPredicate = predicate {
            store.fetchReminders(matching: aPredicate, completion: {(_ reminders: [Any]?) -> Void in
                self.theData = []
                for remind: EKReminder? in reminders as? [EKReminder?] ?? [EKReminder?]() {
                    let reminderStruct = Reminder(title: remind?.title ?? "",id:remind?.calendarItemIdentifier ?? "", isCompleted:remind?.isCompleted ?? false, notes:remind?.notes ?? nil)
//                    if(!reminderStruct.isCompleted) {
                        self.theData.append(reminderStruct)
//                    }
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
        let button = doneButtonConfiguration(for: theData[indexPath.row])
        
        cell.accessoryView = button
        button.sizeToFit()
        if theData.count <= indexPath.row {
            return cell
        }
        cell.textLabel!.text = theData[indexPath.row].title
        return cell
    }
    
    func tableView(_ tableView: UITableView, accessoryButtonTappedForRowWith indexPath: IndexPath) {
        completeReminder(with: theData[indexPath.row].id)
    }
    
    
    func updateReminders() {
        Task {
            do {
                try self.getReminders()
            } catch Errors.accessDenied {
                self.showError(Errors.accessDenied)
            } catch {
                self.showError(error)
            }
        }
    }
    
    @objc func didPressDoneButton(_ sender: ReminderDoneButton) {
        guard let id = sender.id else { return }
    
        completeReminder(with: id)
    }
    
    @objc func eventStoreChanged(_ notification: NSNotification) {
        updateReminders()
    }
    
    private func getItem(with id: String) throws -> EKReminder {
        guard let ekReminder = store.calendarItem(withIdentifier: id) as? EKReminder else {
            throw Errors.failedReadItem
        }
        return ekReminder
    }
    
    func completeReminder(with id: String) {
        var reminder = theData[theData.indexOfReminder(with: id)]
        reminder.isCompleted.toggle()
        print("completed")
        update(reminder, with: id)
        do {
            try self.getReminders()
        } catch Errors.accessDenied {
            self.showError(Errors.accessDenied)
        } catch {
            self.showError(error)
        }
    }
    
    func save(_ reminder:Reminder) throws -> String {
        guard accessGranted else {
            throw Errors.accessDenied
        }
        let ekReminder: EKReminder
        do {
            ekReminder = try getItem(with: reminder.id)
        } catch {
            ekReminder = EKReminder(eventStore: store)
        }
        ekReminder.update(using: reminder, in: store)
        try store.save(ekReminder, commit: true)
        return ekReminder.calendarItemIdentifier
        
    }
    
    func add(_ reminder: Reminder) {
        var reminder = reminder
        do {
            let idFromStore = try save(reminder)
            reminder.id = idFromStore
            theData.append(reminder)
        } catch {
            self.showError(error)
        }
    }
    func update(_ reminder: Reminder, with id: String) {
        do {
            try save(reminder)
            let index = theData.indexOfReminder(with: id)
            theData[index] = reminder
        } catch {
            showError(error)
        }
    }
    
}
