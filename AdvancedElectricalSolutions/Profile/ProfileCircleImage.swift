//
//  ProfileCircleImage.swift
//  AES
//
//  Created by Josias Ballard on 1/29/22.
//

import SwiftUI

struct ProfileCircleImage: View {
    
    @ObservedObject private var vm = MainMessagesViewModel()
    
    var body: some View {
        Image(vm.userProfile?.imageName ?? "")
            .resizable()
            .frame(width: 250, height: 200)
            .clipShape(Circle())
            .overlay {
                Circle().stroke(.white, lineWidth: 4)
            }
            .shadow(radius: 7)
    }
}

struct ProfileCircleImage_Previews: PreviewProvider {
    static var previews: some View {
        ProfileCircleImage()
    }
}
