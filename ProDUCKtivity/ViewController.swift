//
//  ViewController.swift
//  ProDUCKtivity
//
//  Created by Michael Filippini on 11/3/22.
//

import UIKit
import UserNotifications
import CoreData


class ViewController: UIViewController {

    
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var timerLabel: UILabel!
    @IBOutlet weak var startButton: UIButton!
    
    var isInFocusMode = false
    var focusTimer = Timer()
    var focusTime = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupNotifications()
        displayUnfocusedState()
    }
    
    func setupNotifications(){
        //permiss
        let cent = UNUserNotificationCenter.current()
        
        cent.requestAuthorization(options: [.alert, .sound])
        { (granted, error) in
            
        }
        //notif content
        let content = UNMutableNotificationContent()
        content.title = "Get Quackin'!"
        content.body = "Come back and get on track!"
        
        //trigger
        
        var dateComps = DateComponents()
        dateComps.calendar = Calendar.current
//        let dateComps = Calendar.current.dateComponents([.year, .month, .day, .minute, .second], from: date)
        
     
        dateComps.hour = 21
        dateComps.minute = 40
        
        
        let trigger = UNCalendarNotificationTrigger (dateMatching: dateComps, repeats: true)
        //create req
        let strNot = UUID().uuidString
        let req = UNNotificationRequest(identifier: strNot, content: content, trigger: trigger)
        
        cent.add(req) { (error) in
            
        }
    }
    
    
    
    //sec adding in menu
    
    let usersItem = UIAction(title: "Users", image: UIImage(systemName: "person.fill")) { (action) in

             print("Users action was tapped")
        }

        let addUserItem = UIAction(title: "Add User", image: UIImage(systemName: "person.badge.plus")) { (action) in

            print("Add User action was tapped")
        }

        let removeUserItem = UIAction(title: "Remove User", image: UIImage(systemName: "person.fill.xmark.rtl")) { (action) in
             print("Remove User action was tapped")
        }

        let menu = UIMenu(title: "My Menu", options: .displayInline, children: [usersItem , addUserItem , removeUserItem])
  
    //end sec
    
    func displayUnfocusedState(){
        timerLabel.isHidden = true
        messageLabel.text = "Get your ducks in a row!"
        startButton.setTitle("Get Focused", for: .normal)
    }
    
    func displayFocusedState(){
        timerLabel.text = "0:00"
        timerLabel.isHidden = false
        messageLabel.text = "You're doing great! Keep Flappin'"
        startButton.setTitle("End Focus", for: .normal)
        //courtney add in here --> showing menu https://medium.nextlevelswif.com/creating-a-native-popup-menu-over-a-uibutton-or-uinavigationbar-645edf0329c4
    }
    
    
    @IBAction func focusButtonClicked(_ sender: Any) {
        isInFocusMode = !isInFocusMode
        
        if isInFocusMode {
            displayFocusedState()
            startFocusTimer()
        }
        else {
            displayUnfocusedState()
            logFocusSession()
        }
    }
    
    func logFocusSession(){
        focusTimer.invalidate()
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            focusTime = 0
            return
        }
        
        let context = appDelegate.persistentContainer.viewContext
        
        let entity = NSEntityDescription.entity(forEntityName: "FocusSession", in: context)!
        let focusSession = NSManagedObject(entity: entity, insertInto: context)
        
        focusSession.setValue(Date(), forKey: "date")
        focusSession.setValue(focusTime, forKey: "duration")
        focusSession.setValue("study", forKey: "category")

        do {
            try context.save()
        } catch {
 
        }
        
        focusTime = 0
    }
    
    func startFocusTimer(){
        focusTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(self.updateTime), userInfo: nil, repeats: true)
    }
    
    @objc func updateTime(){
        focusTime += 1
        let minutes = focusTime/60
        let seconds = focusTime%60
        timerLabel.text = String(format: "%d:%02d", minutes, seconds)
    }


}

