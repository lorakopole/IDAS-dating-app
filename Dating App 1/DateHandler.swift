//
//  DateHandler.swift
//  IDAS
//
//  Created by Karol Jagiełło
//

import Foundation
import SwiftUI


struct DateHandler
{
    static private let formatter = DateFormatter()
    
    
    static func DateToString(date : Date) -> String
    {
        formatter.dateFormat = "dd/MM/YYYY"
        return formatter.string(from: date)
        
    }
    
    static func CountYearsFromNow(date: Date) -> String
    {
        let calcAge = Calendar.current.dateComponents([.year], from: date, to: Date.now)
        return "\(String(describing: calcAge.year!))"
    }
    
    static func CountYearsFromNow(date: String) -> String
    {
        let calcAge = Calendar.current.dateComponents([.year], from: StringToDate(date: date), to: Date.now)
        return "\(String(describing: calcAge.year!))"
    }
    
    
    
    static func StringToDate(date: String) -> Date
    {
        //print("Przekazana data: \(date)")
        formatter.dateFormat = "dd/MM/yyyy"
        let ret = formatter.date(from: date) ?? Date.now
        //print("\(ret.formatted())")
        return ret
    }
    
    static func StringToString(date: String) -> String
    {
        formatter.dateFormat = "dd/MM/yyyy"
        let dd = formatter.date(from: date) ?? Date.now
        return formatter.string(from: dd)
        
    }
}

