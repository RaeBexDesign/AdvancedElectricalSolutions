//
//  TabBarView.swift
//  AES
//
//  Created by Josias Ballard on 1/26/22.
//

import SwiftUI

enum Tabs: String {
    case today
    case jobs
    case timelog
    case messages
}

struct TabBarView: View {
    
    @EnvironmentObject var viewModel: AppViewModel
    
    @State var selectedTab : Int = 0
    
    var body: some View {
        
        TabView(selection: $selectedTab) {
            
            TodayView()
                .tabItem {
                    Image (systemName: "doc.text.image")
                    Text("Today")
                }
                
            
            ProjectsListView()
                .tabItem {
                    Image (systemName: "bolt")
                    Text("Jobs")
                }
            
            
            TimeLogView(userProfile: nil)
                .tabItem {
                    Image (systemName: "calendar")
                    Text("Time Logs")
                }
            
            
            ChatView()
                .tabItem {
                    Image (systemName: "message")
                    Text("Messages")
                }
            
            
            
        }
        
    }
}

struct TabBarView_Previews: PreviewProvider {
    static var previews: some View {
        TabBarView()
    }
}
