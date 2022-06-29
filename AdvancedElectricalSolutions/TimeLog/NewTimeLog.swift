//
//  NewTimeLog.swift
//  AES
//
//  Created by Josias Ballard on 1/31/22.
//

import SwiftUI
import Firebase
import FirebaseFirestoreSwift
import FirebaseAuth

struct TimeLogSubmissions: Identifiable {
    
    var id: String { documentId }
    
    let documentId: String
    
    let wageType: String
    let date: String
    let jobID: String
    let startTime: String
    let endTime: String
    let total: String
    
    init(documentId: String, data: [String: Any]) {
        self.documentId = documentId
        self.wageType = data["Wage Type"] as? String ?? ""
        self.date = data["Date"] as? String ?? ""
        self.jobID = data["Job ID"] as? String ?? ""
        self.startTime = data["Start Time"] as? String ?? ""
        self.endTime = data["End Time"] as? String ?? ""
        self.total = data["Total"] as? String ?? ""
    }
}


struct NewTimeLog: View {
    
    @Environment(\.presentationMode) var presentationMode
    
    let userProfile: UserProfile?
    
    @ObservedObject var vm = MainMessagesViewModel()
    @ObservedObject var viewModel = TimeLogViewModel(userProfile: nil)
    
    var body: some View {
        NavigationView {
            
            Form {
                Section(header: Text("New Time Submission "), footer: Text("This submission is for \(vm.userProfile?.username ?? "").")) {
                    
                    Picker("Wage Type", selection: $viewModel.selectedWageType) {
                        Text("Hourly").tag(TimeLogViewModel.WageType.Hourly)
                        Text("Overtime").tag(TimeLogViewModel.WageType.Overtime)
                        Text("Vacation").tag(TimeLogViewModel.WageType.Vacation)
                        Text("Holiday").tag(TimeLogViewModel.WageType.Holiday)
                    }
                    
                    DatePicker("Date", selection: $viewModel.date, displayedComponents: .date)
                    
                    TextField("Job ID", text: $viewModel.jobID)
                    
                    DatePicker("Start Time", selection: $viewModel.startTime, displayedComponents: .hourAndMinute)
                    
                    DatePicker("End Time", selection: $viewModel.endTime, displayedComponents: .hourAndMinute)
                    
                    Text("Total: \(viewModel.dateFormatter.string(from: viewModel.totalTime) ?? "")")
                    
                }
            }
            .pickerStyle(.segmented)
            .toolbar {
                ToolbarItemGroup(placement: .navigationBarLeading) {
                    Button {
                        presentationMode.wrappedValue.dismiss()
                    } label: {
                        Text("Cancel")
                    }
                }
                
                ToolbarItemGroup(placement: .navigationBarTrailing) {
                    
                    // Hide Keyboard
                    Button {
                        hideKeyboard()
                    } label: {
                        Image(systemName: "keyboard.chevron.compact.down")
                    }
                    
                    // Submit Button
                    Button {
                        viewModel.handleSubmission()
                    } label: {
                        Text("Submit")
                    }
                    .buttonStyle(.bordered)
                    
                }
            }
        }
        
        
    }
}

struct NewTimeLog_Previews: PreviewProvider {
    static var previews: some View {
        NewTimeLog(userProfile: nil)
    }
}

#if canImport(UIKit)
extension View {
    func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}
#endif
