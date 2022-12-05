//
//  DateStackItem.swift
//  ProDUCKtivity
//
//  Created by Michael Filippini on 12/3/22.
//

import UIKit

class DateStackItem: UIView {
    
    init(dayOfWeek: String, date: String) {
        
        let viewFrame = CGRect(x: 0, y: 0, width: 40, height: 60)
        
        super.init(frame: viewFrame)
        
        let dayOfWeekLabelFrame = CGRect(x: 0, y: 0, width: 40, height: 30)
        let dayOfWeekLabel = UILabel(frame: dayOfWeekLabelFrame)
        dayOfWeekLabel.text = dayOfWeek
        dayOfWeekLabel.textAlignment = .center
        
        let dateFrame = CGRect(x: 0, y: 30, width: 40, height: 30)
        let dateLabel = UILabel(frame: dateFrame)
        dateLabel.text = date
        dateLabel.textAlignment = .center

        
        self.addSubview(dayOfWeekLabel)
        self.addSubview(dateLabel)
        
        self.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.widthAnchor.constraint(equalToConstant: 40)
        ])
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
