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
    var todaysYear = 0
    var viewingWeekNumer = 0
    var viewingYear = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setWeekNumbers()
        addSwipeFunctionality()
        setupCollectionView()
    }
    
    func setWeekNumbers(){
        let calendar = Calendar(identifier: .iso8601)
        let weekNumber = calendar.component(.weekOfYear, from: Date.now)
        let year = calendar.component(.year, from: Date.now)

        todaysWeekNumber = weekNumber
        viewingWeekNumer = weekNumber
        
        todaysYear = year
        viewingYear = year
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
        if viewingYear < todaysYear ||  viewingWeekNumer < todaysWeekNumber {
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
        components.year = viewingYear

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

        
        var components = DateComponents()
        components.weekOfYear = viewingWeekNumer
        components.year = viewingYear
        
        
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
        
        cell.colorBarView.backgroundColor = categoriesToColor[category] ?? UIColor(named: "RedAppColor")
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
        return CGSize(width: 280, height: 80)
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
