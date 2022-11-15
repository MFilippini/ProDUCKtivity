//
//  ViewController.swift
//  ProDUCKtivity
//
//  Created by Michael Filippini on 11/3/22.
//

import UIKit
import UserNotifications


class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
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


}

