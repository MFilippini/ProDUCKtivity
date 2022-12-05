//
//  SessionDetailViewController.swift
//  ProDUCKtivity
//
//  Created by Michael Filippini on 12/5/22.
//

import UIKit
import CoreData

class SessionDetailViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {

    @IBOutlet weak var durationLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var categoryPicker: UIPickerView!

    var session: NSManagedObject? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        pickerViewSetup()
        fillSessionInformation()
    }
    
    func pickerViewSetup(){
        categoryPicker.dataSource = self
        categoryPicker.delegate = self
    }
    
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return userCategories.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return userCategories[row]
    }
    
    func fillSessionInformation(){
        let date = session?.value(forKey: "date") as! Date
        let duration = session?.value(forKey: "duration") as! Int
        let category = session?.value(forKey: "category") as! String
        
        let monthYearText = date.formatted(Date.FormatStyle().month(.twoDigits).day(.defaultDigits))
        let hourMinuteText = date.formatted(Date.FormatStyle().hour().minute())
        
        timeLabel.text = "\(monthYearText) at \(hourMinuteText)"
        
        if duration > 60 {
            durationLabel.text = "\(duration/60) minutes"
        }
        else {
            durationLabel.text = "\(duration/60) min \(duration%60) sec"
        }
    }
    
    @IBAction func saveButtonPressed(_ sender: Any) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        
        let context = appDelegate.persistentContainer.viewContext
        
        if let session = session {
            
            session.setValue("Read", forKey: "category")

            do {
                try context.save()
            } catch {
                let errorDecoding = UIAlertController(title: "Error Saving Session", message: "We couldn't save this session", preferredStyle: .alert)
                errorDecoding.addAction(UIAlertAction(title: "Ok", style: .cancel))
                self.present(errorDecoding, animated: true, completion: nil)
            }
        }
        
        self.dismiss(animated: true)
    }
    
    @IBAction func deleteButtonPressed(_ sender: Any) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        
        let context = appDelegate.persistentContainer.viewContext
        
        if let session = session {
            context.delete(session)
            
            do {
                try context.save()
            } catch {
                let errorDecoding = UIAlertController(title: "Error Removing Session", message: "We couldn't remove this session", preferredStyle: .alert)
                errorDecoding.addAction(UIAlertAction(title: "Ok", style: .cancel))
                self.present(errorDecoding, animated: true, completion: nil)
            }
        }
        
        self.dismiss(animated: true)
        
    }
    
}
