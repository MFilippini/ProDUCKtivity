//
//  GraphStackItem.swift
//  ProDUCKtivity
//
//  Created by Michael Filippini on 12/3/22.
//

import UIKit

class GraphStackItem: UIView {

    init(dataForBar: [[String:Any]], maxWeeklyTime: Double) {
        
        var totalTime = 0.0
        
        for session in dataForBar {
            totalTime += session["length"] as? Double ?? 0
        }
        
        let totalHeight = totalTime * (240.0/maxWeeklyTime)
        let barFrame = CGRect(x: 0, y: 0, width: 40, height: totalHeight)
        
        super.init(frame: barFrame)
        
        
        var currentPosition = 0.0
        
        for session in dataForBar {
            let sessionTime = session["length"] as? Double ?? 0
            let height = sessionTime * (240.0/maxWeeklyTime)
            let barFrame = CGRect(x: 0, y: currentPosition, width: 40, height: height)
            
            let bar = UIView(frame: barFrame)
            bar.backgroundColor = session["color"] as? UIColor ?? .red
            
            self.addSubview(bar)
            currentPosition += height
        }
        
        self.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.widthAnchor.constraint(equalToConstant: 40),
            self.heightAnchor.constraint(equalToConstant: totalHeight)
        ])
        
        
        let longPressRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(longPressed))
        self.addGestureRecognizer(longPressRecognizer)
            
    }
    
    @objc func longPressed(sender: UITapGestureRecognizer){
        var label = UILabel(frame: CGRect(x: 0, y: -20, width: 40, height: 20))
        label.font = UIFont.systemFont(ofSize: 12)
        label.layer.backgroundColor = CGColor(gray: 1, alpha: 0.8)
        label.layer.cornerRadius = 10
        label.text = "test"
        self.addSubview(label)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
