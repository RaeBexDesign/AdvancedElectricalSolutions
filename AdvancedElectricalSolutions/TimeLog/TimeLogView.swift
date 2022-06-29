//
//  TimeLogView.swift
//  AES
//
//  Created by Josias Ballard on 1/26/22.
//

import SwiftUI
import Firebase
import FirebaseAuth
import FirebaseFirestoreSwift

class TimeLogViewModel: ObservableObject {
    
    @ObservedObject var vm = MainMessagesViewModel()
    
    @Published var errorMessage = ""
    @Published var userProfile: UserProfile?
    @Published var isUserCurrentlyLoggedOut = false
    
    @Published var selectedWageType: WageType = .Hourly
    @Published var date = Date()
    @Published var jobID = ""
    @Published var startTime = Date()
    @Published var endTime = Date()
    
    static let username = "username"
    
    @Published var timeLogSubmissions = [TimeLogSubmissions]()
    
    init(userProfile: UserProfile?) {
        self.userProfile = userProfile
        
        DispatchQueue.main.async {
            self.isUserCurrentlyLoggedOut = FirebaseManager.shared.auth.currentUser?.uid == nil
        }
        
        fetchCurrentUser()
        
        fetchTimelogs()
    }
    
    func fetchTimelogs() {
        
//        guard let uid = vm.userProfile?.username else { return }
                
        FirebaseManager.shared.firestore
            .collection("Timelogs")
            .document("Users")
        // Need to set to current user!
            .collection("Josias Ballard")
        //\(vm.userProfile?.username ?? "")
            .order(by: "Date")
            .addSnapshotListener { querySnapshot, error in
                if let error = error {
                    self.errorMessage = "Failed to listen for time submissions: \(error)"
                    print(error)
                    return
                }
                
                querySnapshot?.documentChanges.forEach({ change in
//                    if change.type == .added {
                        let docId = change.document.documentID
                        self.timeLogSubmissions.append(.init(documentId: docId, data: change.document.data()))
//                    }
                })
                
//                querySnapshot?.documents.forEach({ queryDocumentSnapshot in
//                    let data = queryDocumentSnapshot.data()
//                    let docId = queryDocumentSnapshot.documentID
//                    self.timeLogSubmissions.append(.init(documentId: docId, data: data))
//                })
            }
    }
    
    func handleSubmission() {
        print(selectedWageType.rawValue)
        print(date.formatted(Date.FormatStyle().month().day().year()))
        print(jobID)
        print(startTime.formatted(Date.FormatStyle().hour().minute()))
        print(endTime.formatted(Date.FormatStyle().hour().minute()))
        print(dateFormatter.string(from: totalTime) ?? "")
        
        
        let document =
        FirebaseManager.shared.firestore
            .collection("Timelogs")
            .document("Users")
            .collection("\(vm.userProfile?.username ?? "")")
            .document()
        
        
        let timelogData =
        [
        "Wage Type": selectedWageType.rawValue,
        "Date": date.formatted(Date.FormatStyle().month().day().year()),
        "Job ID": jobID,
        "Start Time": startTime.formatted(Date.FormatStyle().hour().minute()),
        "End Time": endTime.formatted(Date.FormatStyle().hour().minute()),
        "Total": dateFormatter.string(from: totalTime) ?? ""
        ] as [String : Any]

        document.setData(timelogData) { error in
            if let error = error {
                print(error)
                self.errorMessage = "Failed to save TimeLog Submission to Firestore: \(error)"
                return
            }

            print("Successfully saved TimeLog Submission to Firestore")
        }
        
    }
    
    func fetchCurrentUser() {
        guard let uid = FirebaseManager.shared.auth.currentUser?.uid else {
            self.errorMessage = "Could not find firebase uid"
            return
        }
        
        FirebaseManager.shared.firestore.collection("users").document(uid).getDocument { snapshot, error in
            if let error = error {
                self.errorMessage = "Failed to fetch current user: \(error)"
                print("Failed to fetch user:", error)
                return
            }
            
            self.userProfile = try? snapshot?.data(as: UserProfile.self)
            FirebaseManager.shared.currentUser = self.userProfile
        }
    }
    
    var totalTime: TimeInterval {
           // This provides a time interval (difference between 2 dates in seconds as a Double
        endTime.timeIntervalSince(startTime)
       }

       // The DateComponentsFormatter handles how that time interval is displayed
       var dateFormatter: DateComponentsFormatter {
           let df = DateComponentsFormatter()
           // Limits the display to hours and mintues
           df.allowedUnits = [.hour, .minute]
           // Adds short units to hour and minutes as hr & min
           df.unitsStyle = .short
           return df
       }
    
    enum WageType: String, CaseIterable, Identifiable {
        case Hourly = "Hourly"
        case Overtime = "Overtime"
        case Vacation = "Vacation"
        case Holiday = "Holiday"
        var id: Self { self }
    }
}


struct TimeLogView: View {
    
    @ObservedObject var vm = MainMessagesViewModel()
    @ObservedObject var viewModel = TimeLogViewModel(userProfile: nil)
    
    @State var shouldNavigateToLogView = false
    
    var userProfile: UserProfile?

    init(userProfile: UserProfile?) {
        self.userProfile = userProfile

        viewModel.fetchTimelogs()

    }
    
    
    var body: some View {
        NavigationView {
            VStack {
                
                HStack {
                    
                    Text("Time Logs")
                        .font(.largeTitle)
                        .bold()
                        .foregroundColor(.primary)
                        .padding(.leading)
                    
                    Spacer()
                    
                    NavigationLink(destination: ProfileView()) {
                        Image(systemName: "person.circle")
                            .scaleEffect(3)
                    }
                    
                }
                .padding(.vertical)
                .padding(.trailing, 25)
                
                Divider()
                
                logsView
                
                NavigationLink("", isActive: $shouldNavigateToLogView) {
                    LogsView()
//                insert in parenthesis above - viewModel: TimeLogViewModel
                }
                
                Spacer()
                
            }
            .navigationBarHidden(true)
            .overlay(newTimeSubmissionButton, alignment: .bottom)
            
        }
    }



private var logsView: some View {
    ScrollView {
        
        ForEach(viewModel.timeLogSubmissions) { timesubmissions in
            VStack {
                Button {
//                    let uid = FirebaseManager.shared.auth.currentUser?.uid
//                    self.userProfile = .init(id: uid, username: timesubmissions.username)
                    
                    self.viewModel.userProfile = self.userProfile
//                    self.viewModel.fetchTimelogs()
                    self.shouldNavigateToLogView.toggle()
                } label: {
                    HStack() {
                        Text(timesubmissions.date)
                            .font(.callout)
                            .fontWeight(.semibold)
                            .foregroundColor(Color(.label))
                        
                        Spacer()
                        
//                        Text("\(timesubmissions.total)")
//                            .font(.callout)
//                            .fontWeight(.medium)
//                            .foregroundColor(Color(.label))
//
//                        Spacer()
                        
                        Text(timesubmissions.jobID)
                            .font(.callout)
                            .fontWeight(.medium)
                            .foregroundColor(Color(.label))
                        
//                        Spacer()
//
//                        Text("\(timesubmissions.wageType)")
//                            .font(.callout)
//                            .fontWeight(.medium)
//                            .foregroundColor(Color(.label))
                    }
                }
                
                Divider()
                
            }
            .padding(.horizontal)
            .padding(.vertical, 8)
            
        }
        .padding(.bottom, 50)
        
        
    }
}
    
    @State var shouldShowNewTimeLogScreen = false
    
    private var newTimeSubmissionButton: some View {
        Button {
            shouldShowNewTimeLogScreen.toggle()
        } label: {
            HStack {
                Spacer()
                Text("+ New Time Submission")
                    .font(.system(size: 16, weight: .bold))
                Spacer()
            }
            .foregroundColor(.white)
            .padding(.vertical)
            .background(Color.blue)
            .cornerRadius(32)
            .padding(.horizontal)
            .shadow(radius: 15)
        }
        .fullScreenCover(isPresented: $shouldShowNewTimeLogScreen) {
            NewTimeLog(userProfile: nil)
        }
        .padding(.bottom)
    }
    
}

struct TimeLogView_Previews: PreviewProvider {
    static var previews: some View {
        TimeLogView(userProfile: nil)
    }
}
