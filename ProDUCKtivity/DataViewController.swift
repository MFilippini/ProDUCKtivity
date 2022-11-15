//
//  DataViewController.swift
//  ProDUCKtivity
//
//  Created by Michael Filippini on 11/10/22.
//

import UIKit
import CoreData

class DataViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var pastSessionsTableView: UITableView!

    var pastSessions: [NSManagedObject] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadSessionData()
        pastSessionsTableView.reloadData()
    }
    
    func setupTableView(){
        pastSessionsTableView.delegate = self
        pastSessionsTableView.dataSource = self
        
        pastSessionsTableView.register(UITableViewCell.self, forCellReuseIdentifier: "focusSessionCell")
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return pastSessions.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = pastSessionsTableView.dequeueReusableCell(withIdentifier: "focusSessionCell", for: indexPath)
        let session = pastSessions[indexPath.row]
        
        let date = session.value(forKey: "date") as? Date
        cell.textLabel?.text = date?.formatted(Date.FormatStyle().month(.twoDigits).day(.defaultDigits))

        return cell
    }
    
    func loadSessionData(){
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        
        let context = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "FocusSession")
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "date", ascending: false)]
        
        do {
            pastSessions = try context.fetch(fetchRequest)
        } catch {
            let errorDecoding = UIAlertController(title: "We Couldn't Find Your Data", message: "Don't remember your past session data!", preferredStyle: .alert)
            errorDecoding.addAction(UIAlertAction(title: "Ok", style: .cancel))
            self.present(errorDecoding, animated: true, completion: nil)
        }
    }

}
