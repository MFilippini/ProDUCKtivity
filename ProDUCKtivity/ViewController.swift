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
    
   
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        startButton.menu = showMenu()
//        startButton.showsMenuAsPrimaryAction = true
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
    let cat1 = UIAction(title: "cooking", image: UIImage(systemName: "cart")) { (action) in

             print("cooking action was tapped")
        }

        let cat2 = UIAction(title: "sleeping", image: UIImage(systemName: "moon")) { (action) in

            print("sleeping action was tapped")
            
        }

        let cat3 = UIAction(title: "studying", image: UIImage(systemName: "pencil")) { (action) in
             print("studying was tapped")
        }
 
    func showMenu() -> UIMenu {
        let menuIts = UIMenu(title: "Select options", options: .displayInline, children: [cat1,cat2,cat3])
        
        return menuIts
        
    }
 

   //idea for showing how pop up connects
        //func for each category that changes a text label to say what you're focusing on
    //topLabel.text = Keep focusing on *whatever u picked* 
     
   
    //func for alert view - study clean read
    func alertYuh() {
        let alert = UIAlertController(title: "Welcome", message: "Please select a category", preferredStyle: .actionSheet)
               alert.addAction(UIAlertAction(title: "Study", style: .default, handler: { (_) in
                   print("User chose study button")
                   self.focusLabel.text = "You are focusing on studying!"
               }))

               alert.addAction(UIAlertAction(title: "Clean", style: .default, handler: { (_) in
                   print("User click clean button")
                   self.focusLabel.text = "You are focusing on cleaning!"
               }))

               alert.addAction(UIAlertAction(title: "Read", style: .default, handler: { (_) in
                   print("User click read button")
                   self.focusLabel.text = "You are focusing on reading!"
               }))

               alert.addAction(UIAlertAction(title: "Dismiss", style: .cancel, handler: { (_) in
                   print("User click Dismiss button")
               }))

               self.present(alert, animated: true, completion: {
                   print("completion block")
               })
           }

  
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

