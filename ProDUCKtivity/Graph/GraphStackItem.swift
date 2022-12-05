//
//  GraphStackItem.swift
//  ProDUCKtivity
//
//  Created by Michael Filippini on 12/3/22.
//

import UIKit

class GraphStackItem: UIView {
    
    var timeLabelIsDisplayed = false
    var timeLabel: UILabel? = nil

    init(dataForBar: DailyGraphData, maxWeeklyTime: Double) {
        
        var totalTime = 0.0
        
        for (_, categoryData) in dataForBar {
            totalTime += Double(categoryData.categoryTime)
        }
        
        var totalHeight = totalTime * (240.0/maxWeeklyTime)
        
        if maxWeeklyTime <= 0 {
            totalHeight = 1
        }
        
        let barFrame = CGRect(x: 0, y: 0, width: 40, height: totalHeight)
        
        super.init(frame: barFrame)
        
        var currentPosition = 0.0
        
        for (_, categoryData) in dataForBar {
            let sessionTime = Double(categoryData.categoryTime)
            let height = sessionTime * (240.0/maxWeeklyTime)
            let barFrame = CGRect(x: 0, y: currentPosition, width: 40, height: height)
            
            let bar = UIView(frame: barFrame)
            bar.backgroundColor = categoryData.categoryColor
            
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
            
        timeLabel = UILabel(frame: CGRect(x: 5, y: 5, width: 40, height: 25))
        timeLabel?.font = UIFont.systemFont(ofSize: 12)
        timeLabel?.layer.backgroundColor = CGColor(gray: 1, alpha: 0.85)
        timeLabel?.layer.borderWidth = 1
        timeLabel?.layer.borderColor = CGColor(gray: 0.8, alpha: 0.85)
        timeLabel?.textAlignment = .center
        timeLabel?.layer.shadowColor = CGColor(gray: 0.8, alpha: 0.85)
        timeLabel?.text = String(format: "%.1f hrs", totalTime/(60*60))
        timeLabel?.isHidden = true
        self.addSubview(timeLabel!)
        self.bringSubviewToFront(timeLabel!)

    }
    
    @objc func longPressed(sender: UITapGestureRecognizer){
        
        // prevents label rapid flickering if user longPress then drags
        if sender.state == .changed {
            return
        }
        
        timeLabel?.isHidden = timeLabelIsDisplayed
        timeLabelIsDisplayed = !timeLabelIsDisplayed
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
