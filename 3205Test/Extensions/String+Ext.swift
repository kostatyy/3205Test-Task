//
//  String+Ext.swift
//  3205Test
//
//  Created by Macbook Pro on 31.07.2021.
//

import Foundation

extension String {
    //MARK: - Format Date To String
    func formatDate() -> String {
        let formatter = ISO8601DateFormatter()
        let yourDate = formatter.date(from: self)
        let dayTimePeriodFormatter = DateFormatter()
        dayTimePeriodFormatter.dateFormat = "d MMMM YYYY"
        
        guard let date = yourDate else { return "-" }
        let dateString = dayTimePeriodFormatter.string(from: date as Date)
        return dateString
    }
}
