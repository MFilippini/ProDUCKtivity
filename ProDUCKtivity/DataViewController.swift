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
    
    @IBOutlet weak var graphContainerView: UIView!
    @IBOutlet weak var graphStackView: UIStackView!
    @IBOutlet weak var dateStackView: UIStackView!
    
    var pastSessions: [NSManagedObject] = []
    var dateKeyedSessionData: DateKeyedSessionData = [:]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCollectionView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadSessionData()
        setupGraph()
        pastSessionsCollectionView.reloadData()
    }
    
    func setupGraph(){
        clearGraphAndData()
        keySessionData()
        setupDateBar()
        addDataToGraphs()
    }
    
    func clearGraphAndData() {
        dateKeyedSessionData = [:]
        
        for arrangedSubview in graphStackView.arrangedSubviews {
            arrangedSubview.removeFromSuperview()
        }
        
        for arrangedSubview in dateStackView.arrangedSubviews {
            arrangedSubview.removeFromSuperview()
        }
        
    }
    
    func keySessionData(){
        
        for session in pastSessions {
            let date = session.value(forKey: "date") as! Date
            let duration = session.value(forKey: "duration") as! Int
            let category = session.value(forKey: "category") as! String
            
            let dateKey = date.formatted(dateKeyFormatStyle)

            if dateKeyedSessionData[dateKey] == nil {
                dateKeyedSessionData[dateKey] = [:]
            }
                
            if dateKeyedSessionData[dateKey]?[category] == nil {
                dateKeyedSessionData[dateKey]?[category] = CategoryGraphData(categoryTime: duration, categoryColor: .red)
            }
            else {
                dateKeyedSessionData[dateKey]?[category]?.categoryTime += duration
            }
            
        }
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
    
    func addDataToGraphs(){
                
        let calendar = Calendar(identifier: .iso8601)
        let weekNumber = calendar.component(.weekOfYear, from: Date.now)
        let year = calendar.component(.year, from: Date.now)

        
        var components = DateComponents()
        components.weekOfYear = weekNumber
        components.year = year
        
        
        var maxWeeklyTime = 0
        
        // 2 is Monday and 8 is Sunday
        for weekdayNumber in 2...8 {
            components.weekday = weekdayNumber
            let date = calendar.date(from: components) ?? Date.now
            
            let dateKey = date.formatted(dateKeyFormatStyle)
                        
            if let sessions = dateKeyedSessionData[dateKey] {
                var dailyTotal = 0
                for (_, categoryData) in sessions {
                    dailyTotal += categoryData.categoryTime
                }
                maxWeeklyTime = max(maxWeeklyTime, dailyTotal)
            }
        }
                
        // 2 is Monday and 8 is Sunday
        for weekdayNumber in 2...8 {
            components.weekday = weekdayNumber
            let date = calendar.date(from: components) ?? Date.now
            
            let dateKey = date.formatted(dateKeyFormatStyle)
            
            if let sessions = dateKeyedSessionData[dateKey] {
                let newGraphBar = GraphStackItem(dataForBar: sessions, maxWeeklyTime: Double(maxWeeklyTime))

                graphStackView.addArrangedSubview(newGraphBar)
            }
            else {
                graphStackView.addArrangedSubview(GraphStackItem(dataForBar: [:], maxWeeklyTime: Double(maxWeeklyTime)))
            }
        }
        

        let screenWidth = view.frame.width
        
        

        for i in 0..<4 {
            let yPos = CGFloat(i)*60.0
            
            let graphLine = UIView(frame: CGRect(x: 0, y: CGFloat(i)*60.0, width: screenWidth, height: 1))
            graphLine.backgroundColor = .lightGray
            
            let barLabelTime = (Double(maxWeeklyTime) / 60) * ((4-Double(i))/4.0)
            
            let label = UILabel(frame: CGRect(x: 5, y: yPos-20, width: 40, height: 20))
            label.font = UIFont.systemFont(ofSize: 12)
            label.layer.backgroundColor = CGColor(gray: 1, alpha: 0.8)
            label.layer.cornerRadius = 10
            label.text = String(format: "%.1f hrs", barLabelTime)
            graphContainerView.addSubview(label)
            
            graphContainerView.addSubview(graphLine)
            graphContainerView.sendSubviewToBack(graphLine)
        }
        
    }
    
    
    
    func setupCollectionView(){
        pastSessionsCollectionView.delegate = self
        pastSessionsCollectionView.dataSource = self
        
        pastSessionsCollectionView.layer.borderWidth = 8
        pastSessionsCollectionView.layer.cornerRadius = 40
        pastSessionsCollectionView.layer.borderColor = UIColor(named: "AppColor")?.cgColor
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
        return CGSize(width: 300, height: 80)
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
