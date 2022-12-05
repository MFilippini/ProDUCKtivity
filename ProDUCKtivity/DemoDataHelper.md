#  Adding Demo Data 



Here is some code to add data for testing the program. It is the same data shown in the demo video.


```
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
```
