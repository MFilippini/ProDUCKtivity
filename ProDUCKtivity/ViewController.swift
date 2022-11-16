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
        content.title = "Reminder!"
        content.body = "Come back and get on track!"
        
        //trigger
      //  let date = Date().addingTimeInterval(15)
        
        var dateComps = DateComponents()
        dateComps.calendar = Calendar.current
//        let dateComps = Calendar.current.dateComponents([.year, .month, .day, .minute, .second], from: date)
        
       // dateComps.weekday = 1-7 // Tuesday , comm bc want daily, 1 thru 7??
     
        dateComps.hour = 19    // 19:00 hours
   //     dateComps.minute = 27   // min
        
        
        let trigger = UNCalendarNotificationTrigger (dateMatching: dateComps, repeats: true)
        //create req
        let strNot = UUID().uuidString
        let req = UNNotificationRequest(identifier: strNot, content: content, trigger: trigger)
        
        cent.add(req) { (error) in
            
        }
    }
    
    func displayUnfocusedState(){
        timerLabel.isHidden = true
        messageLabel.text = "Get your ducks in a row!"
        startButton.setTitle("Get Focused", for: .normal)
    }
    
    func displayFocusedState(){
        timerLabel.isHidden = false
        messageLabel.text = "You're doing great! Keep Flappin'"
        startButton.setTitle("End Focus", for: .normal)
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

