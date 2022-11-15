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
        let date = Date().addingTimeInterval(15)
        let dateComps = Calendar.current.dateComponents([.year, .month, .day, .minute, .second], from: date)
        let trigger = UNCalendarNotificationTrigger (dateMatching: dateComps, repeats: false)
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
        }
        else {
            displayUnfocusedState()
        }
    }
    
    
    func addNewFakeData(){
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        
        let context = appDelegate.persistentContainer.viewContext
        
        let entity = NSEntityDescription.entity(forEntityName: "FocusSession", in: context)!
        let focusSession = NSManagedObject(entity: entity, insertInto: context)
        
        focusSession.setValue(Date(), forKey: "date")
        focusSession.setValue(43, forKey: "duration")
        focusSession.setValue("study", forKey: "category")

        do {
            try context.save()
        } catch {
 
        }
    }


}

