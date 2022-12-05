//
//  GraphDataModel.swift
//  ProDUCKtivity
//
//  Created by Michael Filippini on 12/4/22.
//

import Foundation
import UIKit

struct CategoryGraphData {
    var categoryTime : Int
    let categoryColor : UIColor
}

typealias DailyGraphData = [String:CategoryGraphData]

typealias DateKeyedSessionData = [String:DailyGraphData]
let dateKeyFormatStyle = Date.FormatStyle().month(.twoDigits).day(.twoDigits).year()
