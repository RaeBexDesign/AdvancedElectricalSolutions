//
//  DateValue.swift
//  AdvancedElectricalSolutions
//
//  Created by Josias Ballard on 4/5/22.
//

import Foundation

//Date Value Model...
struct DateValue: Identifiable {
    var id = UUID().uuidString
    var day: Int
    var date: Date
}
