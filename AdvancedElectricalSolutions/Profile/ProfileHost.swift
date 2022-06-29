//
//  ProfileHost.swift
//  AES
//
//  Created by Josias Ballard on 1/28/22.
//

import SwiftUI

struct ProfileHost: View {
    
    @ObservedObject private var vm = MainMessagesViewModel()
    
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            ProfileSummary()
                }
                .padding()

    }
}

struct ProfileHost_Previews: PreviewProvider {
    static var previews: some View {
        ProfileHost()
    }
}
