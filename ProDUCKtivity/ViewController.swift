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

    @IBOutlet weak var focusLabel: UILabel!
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var timerLabel: UILabel!
    @IBOutlet weak var startButton: UIButton!
    
    var isInFocusMode = false
    var focusTimer = Timer()
    var focusTime = 0
    var category = ""
   
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTimerLabel()
        setupNotifications()
        displayUnfocusedState()
    }
    
    func setupTimerLabel(){
        timerLabel.font = UIFont.monospacedDigitSystemFont(ofSize: 36.0, weight: .medium)
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
     
        dateComps.hour = 2
        dateComps.minute = 21
        
        
        let trigger = UNCalendarNotificationTrigger (dateMatching: dateComps, repeats: true)
        //create req
        let strNot = UUID().uuidString
        let req = UNNotificationRequest(identifier: strNot, content: content, trigger: trigger)
        
        cent.add(req) { (error) in
            
        }
    }
    
    
   //idea for showing how pop up connects
        //func for each category that changes a text label to say what you're focusing on
    //topLabel.text = Keep focusing on *whatever u picked* 
     
   
    //func for alert view - study clean read
    func alertYuh() {
        let alert = UIAlertController(title: "Welcome", message: "Please select a category", preferredStyle: .actionSheet)
               alert.addAction(UIAlertAction(title: "Study", style: .default, handler: { (_) in
                   self.category = "Study"
                   self.focusLabel.text = "You are focusing on studying!"
               }))

               alert.addAction(UIAlertAction(title: "Clean", style: .default, handler: { (_) in
                   self.category = "Clean"
                   self.focusLabel.text = "You are focusing on cleaning!"
               }))

               alert.addAction(UIAlertAction(title: "Read", style: .default, handler: { (_) in
                   self.category = "Read"
                   self.focusLabel.text = "You are focusing on reading!"
               }))

               self.present(alert, animated: true, completion: {
               })
    }

  
    //end sec
    func displayUnfocusedState(){
        self.view.backgroundColor = .white
        timerLabel.isHidden = true
        messageLabel.text = "Get your ducks in a row!"
        startButton.setTitle("Get Focused", for: .normal)
        
    }
    
    func displayFocusedState(){
        self.view.backgroundColor = UIColor(named: "AppColor")
        timerLabel.text = "0:00"
        timerLabel.isHidden = false
        messageLabel.text = "You're doing great! Keep Flappin'"
        startButton.setTitle("End Focus", for: .normal)
    }
    
    
    @IBAction func focusButtonClicked(_ sender: Any) {
        isInFocusMode = !isInFocusMode
       
        if isInFocusMode {
            alertYuh()
            displayFocusedState()
            startFocusTimer()
        }
        else {
            displayUnfocusedState()
            logFocusSession()
            self.focusLabel.text = ""
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
        focusSession.setValue(category, forKey: "category")

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

