//
//  DataViewController.swift
//  ProDUCKtivity
//
//  Created by Michael Filippini on 11/10/22.

import UIKit
import CoreData

class DataViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    @IBOutlet weak var pastSessionsCollectionView: UICollectionView!
    
    @IBOutlet weak var graphContainerView: UIView!
    @IBOutlet weak var graphStackView: UIStackView!
    @IBOutlet weak var dateStackView: UIStackView!
    
    var pastSessions: [NSManagedObject] = []
    var dateKeyedSessionData: DateKeyedSessionData = [:]
    
    var todaysWeekNumber = 0
    var viewingWeekNumer = 0
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setWeekNumbers()
        addSwipeFunctionality()
        setupCollectionView()
        //addDummyData()
    }
    
    func setWeekNumbers(){
        let calendar = Calendar(identifier: .iso8601)
        let weekNumber = calendar.component(.weekOfYear, from: Date.now)
        
        todaysWeekNumber = weekNumber
        viewingWeekNumer = weekNumber
    }
    
    func addSwipeFunctionality(){
        let swipeLeftRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(graphSwipedLeft))
        swipeLeftRecognizer.direction = .left
        graphStackView.addGestureRecognizer(swipeLeftRecognizer)
        
        let swipeRightRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(graphSwipedRight))
        swipeRightRecognizer.direction = .right
        graphStackView.addGestureRecognizer(swipeRightRecognizer)
    }


    
    // go forward in time
    @objc func graphSwipedLeft(sender: UISwipeGestureRecognizer){
        if viewingWeekNumer < todaysWeekNumber {
            viewingWeekNumer += 1
            clearGraph()
            setupDateBar()
            addDataToGraphs()
        }
    }
    
    // go backwards in time
    @objc func graphSwipedRight(sender: UISwipeGestureRecognizer){
        viewingWeekNumer -= 1
        clearGraph()
        setupDateBar()
        addDataToGraphs()
    }
    
    func addDummyData(){
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        
        let context = appDelegate.persistentContainer.viewContext
    
        
        let secondsPerDay:Double = 60*60*24;
        let secondsPerHour:Double = 60*60;
        
        
        let entity = NSEntityDescription.entity(forEntityName: "FocusSession", in: context)!
        let focusSession = NSManagedObject(entity: entity, insertInto: context)
        
        focusSession.setValue(Date(timeIntervalSinceNow: -14*secondsPerDay), forKey: "date")
        focusSession.setValue(1.5*secondsPerHour, forKey: "duration")
        focusSession.setValue("Study", forKey: "category")
        
        let entity1 = NSEntityDescription.entity(forEntityName: "FocusSession", in: context)!
        let focusSession1 = NSManagedObject(entity: entity1, insertInto: context)
        
        focusSession1.setValue(Date(timeIntervalSinceNow: -14*secondsPerDay), forKey: "date")
        focusSession1.setValue(1*secondsPerHour, forKey: "duration")
        focusSession1.setValue("Clean", forKey: "category")
        
        
        let entity2 = NSEntityDescription.entity(forEntityName: "FocusSession", in: context)!
        let focusSession2 = NSManagedObject(entity: entity2, insertInto: context)
        
        focusSession2.setValue(Date(timeIntervalSinceNow: -13*secondsPerDay), forKey: "date")
        focusSession2.setValue(2*secondsPerHour, forKey: "duration")
        focusSession2.setValue("Read", forKey: "category")
        
        
        let entity3 = NSEntityDescription.entity(forEntityName: "FocusSession", in: context)!
        let focusSession3 = NSManagedObject(entity: entity3, insertInto: context)
        
        focusSession3.setValue(Date(timeIntervalSinceNow: -10*secondsPerDay), forKey: "date")
        focusSession3.setValue(1.25*secondsPerHour, forKey: "duration")
        focusSession3.setValue("Clean", forKey: "category")
        
        
        let entity4 = NSEntityDescription.entity(forEntityName: "FocusSession", in: context)!
        let focusSession4 = NSManagedObject(entity: entity4, insertInto: context)
        
        focusSession4.setValue(Date(timeIntervalSinceNow: -9*secondsPerDay), forKey: "date")
        focusSession4.setValue(1*secondsPerHour, forKey: "duration")
        focusSession4.setValue("Clean", forKey: "category")
        
        
        
        
        let entity5 = NSEntityDescription.entity(forEntityName: "FocusSession", in: context)!
        let focusSession5 = NSManagedObject(entity: entity5, insertInto: context)
        
        focusSession5.setValue(Date(timeIntervalSinceNow: -7*secondsPerDay), forKey: "date")
        focusSession5.setValue(1*secondsPerHour, forKey: "duration")
        focusSession5.setValue("Read", forKey: "category")
        
        
        
        let entity6 = NSEntityDescription.entity(forEntityName: "FocusSession", in: context)!
        let focusSession6 = NSManagedObject(entity: entity6, insertInto: context)
        
        focusSession6.setValue(Date(timeIntervalSinceNow: -6*secondsPerDay), forKey: "date")
        focusSession6.setValue(3*secondsPerHour, forKey: "duration")
        focusSession6.setValue("Study", forKey: "category")
        
        let entity7 = NSEntityDescription.entity(forEntityName: "FocusSession", in: context)!
        let focusSession7 = NSManagedObject(entity: entity7, insertInto: context)
        
        focusSession7.setValue(Date(timeIntervalSinceNow: -6*secondsPerDay), forKey: "date")
        focusSession7.setValue(0.5*secondsPerHour, forKey: "duration")
        focusSession7.setValue("Read", forKey: "category")

        
        let entity8 = NSEntityDescription.entity(forEntityName: "FocusSession", in: context)!
        let focusSession8 = NSManagedObject(entity: entity8, insertInto: context)
        
        focusSession8.setValue(Date(timeIntervalSinceNow: -5*secondsPerDay), forKey: "date")
        focusSession8.setValue(1*secondsPerHour, forKey: "duration")
        focusSession8.setValue("Read", forKey: "category")
        
        let entity9 = NSEntityDescription.entity(forEntityName: "FocusSession", in: context)!
        let focusSession9 = NSManagedObject(entity: entity9, insertInto: context)
        
        focusSession9.setValue(Date(timeIntervalSinceNow: -5*secondsPerDay), forKey: "date")
        focusSession9.setValue(1*secondsPerHour, forKey: "duration")
        focusSession9.setValue("Study", forKey: "category")
        
        
        let entity10 = NSEntityDescription.entity(forEntityName: "FocusSession", in: context)!
        let focusSession10 = NSManagedObject(entity: entity10, insertInto: context)
        
        focusSession10.setValue(Date(timeIntervalSinceNow: -4*secondsPerDay), forKey: "date")
        focusSession10.setValue(1*secondsPerHour, forKey: "duration")
        focusSession10.setValue("Clean", forKey: "category")
        
        
        let entity11 = NSEntityDescription.entity(forEntityName: "FocusSession", in: context)!
        let focusSession11 = NSManagedObject(entity: entity11, insertInto: context)
        
        focusSession11.setValue(Date(timeIntervalSinceNow: -2*secondsPerDay), forKey: "date")
        focusSession11.setValue(2*secondsPerHour, forKey: "duration")
        focusSession11.setValue("Study", forKey: "category")
        
        let entity12 = NSEntityDescription.entity(forEntityName: "FocusSession", in: context)!
        let focusSession12 = NSManagedObject(entity: entity12, insertInto: context)
        
        focusSession12.setValue(Date(timeIntervalSinceNow: -2*secondsPerDay), forKey: "date")
        focusSession12.setValue(0.5*secondsPerHour, forKey: "duration")
        focusSession12.setValue("Clean", forKey: "category")
        
        let entity13 = NSEntityDescription.entity(forEntityName: "FocusSession", in: context)!
        let focusSession13 = NSManagedObject(entity: entity13, insertInto: context)
        
        focusSession13.setValue(Date(timeIntervalSinceNow: -1*secondsPerDay), forKey: "date")
        focusSession13.setValue(1.5*secondsPerHour, forKey: "duration")
        focusSession13.setValue("Study", forKey: "category")
        
        let entity14 = NSEntityDescription.entity(forEntityName: "FocusSession", in: context)!
        let focusSession14 = NSManagedObject(entity: entity14, insertInto: context)
        
        focusSession14.setValue(Date(timeIntervalSinceNow: 0*secondsPerDay), forKey: "date")
        focusSession14.setValue(1.5*secondsPerHour, forKey: "duration")
        focusSession14.setValue("Read", forKey: "category")
        
        do {
            try context.save()
        } catch {
 
        }
        
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
    
    func clearGraph(){
        for arrangedSubview in graphStackView.arrangedSubviews {
            arrangedSubview.removeFromSuperview()
        }
        
        for arrangedSubview in dateStackView.arrangedSubviews {
            arrangedSubview.removeFromSuperview()
        }
    }
    
    func clearGraphAndData() {
        dateKeyedSessionData = [:]
        clearGraph()
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
                let color = categoriesToColor[category] as? UIColor ?? .red
                
                dateKeyedSessionData[dateKey]?[category] = CategoryGraphData(categoryTime: duration, categoryColor: color)
            }
            else {
                dateKeyedSessionData[dateKey]?[category]?.categoryTime += duration
            }
            
        }
    }
    
    func setupDateBar(){
        let calendar = Calendar(identifier: .iso8601)
        
        var components = DateComponents()
        components.weekOfYear = viewingWeekNumer
        
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
        let year = calendar.component(.year, from: Date.now)

        
        var components = DateComponents()
        components.weekOfYear = viewingWeekNumer
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
            
            let barLabelTime = (Double(maxWeeklyTime) / (60*60)) * ((4-Double(i))/4.0)
            
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
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        performSegue(withIdentifier: "toSessionDetail", sender: indexPath)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if let sessionDetailVC = segue.destination as? SessionDetailViewController {
            let indexPath = sender as! IndexPath
            let session = pastSessions[indexPath.row]
            
            sessionDetailVC.session = session
        }
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
