//
//  Task.swift
//  AdvancedElectricalSolutions
//
//  Created by Josias Ballard on 4/5/22.
//

import Foundation

// Task Model and Sample Tasks...
//Array of Tasks...
struct Task: Identifiable {
    var id = UUID().uuidString
    var title: String
    var time: Date = Date()
}

//Total Task Meta View...
struct TaskMetaData: Identifiable {
    var id = UUID().uuidString
    var task: [Task]
    var taskDate: Date
}

//sample Date for Testing...
func getSampleDate(offset: Int)->Date {
    let calendar = Calendar.current
    
    let date = calendar.date(byAdding: .day, value: offset, to: Date())
    
    return date ?? Date()
}

var tasks: [TaskMetaData] = [

    TaskMetaData(task: [
        
        Task(title: "Talk to iJustine"),
        Task(title: "iPhone 13 Great Design Change"),
        Task(title: "Nothing Much Workout !!!")
    ], taskDate: getSampleDate(offset: 1)),
    
    TaskMetaData(task: [
        
        Task(title: "Next Version of SwiftUI"),
        Task(title: "iPhone 13 Great Design Change"),
        Task(title: "Nothing Much Workout !!!")
    ], taskDate: getSampleDate(offset: -8)),
]
