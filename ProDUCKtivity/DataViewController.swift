//
//  DataViewController.swift
//  ProDUCKtivity
//
//  Created by Michael Filippini on 11/10/22.
//

import UIKit
import CoreData

class DataViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    @IBOutlet weak var pastSessionsCollectionView: UICollectionView!
    
    @IBOutlet weak var graphStackView: UIStackView!
    @IBOutlet weak var dateStackView: UIStackView!
    
    var pastSessions: [NSManagedObject] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCollectionView()
        setupGraph()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadSessionData()
        pastSessionsCollectionView.reloadData()
    }
    
    func setupGraph(){
        setupDateBar()
    }
    
    func setupDateBar(){
        let calendar = Calendar(identifier: .iso8601)
        let weekNumber = calendar.component(.weekOfYear, from: Date.now)
        
        var components = DateComponents()
        components.weekOfYear = weekNumber
        
        let weekdayFormat = DateFormatter()
        weekdayFormat.dateFormat = "EEEEE"
        
        // 2 is Monday and 8 is Sunday
        for weekdayNumber in 2...8 {
            components.weekday = weekdayNumber
            let date = calendar.date(from: components) ?? Date.now

            let dateStackItem = DateStackItem(dayOfWeek: weekdayFormat.string(from: date), date: date.formatted(.dateTime.day()))
            dateStackView.addArrangedSubview(dateStackItem)
        }
    }
    
    func setupCollectionView(){
        pastSessionsCollectionView.delegate = self
        pastSessionsCollectionView.dataSource = self
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return pastSessions.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = pastSessionsCollectionView.dequeueReusableCell(withReuseIdentifier: "focusSessionCell", for: indexPath) as! PastSessionCollectionViewCell
        let session = pastSessions[indexPath.row]
        
        let date = session.value(forKey: "date") as! Date
        let duration = session.value(forKey: "duration") as! Int
        let category = session.value(forKey: "category") as! String
        
        cell.dateLabel.text = date.formatted(Date.FormatStyle().month(.twoDigits).day(.defaultDigits))
        cell.categoryLabel.text = category
        
        if duration > 60 {
            cell.durationLabel.text = "\(duration/60) minutes"
        }
        else {
            cell.durationLabel.text = "\(duration/60) min \(duration%60) sec"
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 300, height: 100)
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
