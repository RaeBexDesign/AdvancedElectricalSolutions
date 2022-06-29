//
//  ProfileSummary.swift
//  AES
//
//  Created by Josias Ballard on 1/28/22.
//

import SwiftUI

struct ProfileSummary: View {
    
    @ObservedObject private var vm = MainMessagesViewModel()
    
    var body: some View {
        
        ScrollView {
                    VStack(alignment: .leading, spacing: 10) {
                        Text(vm.userProfile?.username ?? "")
                            .bold()
                            .font(.title)

                        //Text("Notifications: \(vm.userProfile?.prefersNotifications ? "On": "Off" )")
                    }
                }
    }
}

struct ProfileSummary_Previews: PreviewProvider {
    static var previews: some View {
        ProfileSummary()
    }
}
