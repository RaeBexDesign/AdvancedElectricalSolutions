//
//  CurrentProjectView.swift
//  AdvancedElectricalSolutions
//
//  Created by Josias Ballard on 5/19/22.
//

import SwiftUI

struct SelectedProjectView: View {
    
    @ObservedObject private var viewModel = ProjectsListViewModel()
    
    var project: Project
    
    var body: some View {
        ScrollView {
//            ProjectMapView(coordinate: project.locationCoordinate)
//                .ignoresSafeArea(edges: .top)
//                .frame(height: 300)
//            
//            ProjectCircleImage(image: project.image)
//                .offset(y: -85)
//                .padding(.bottom, -110)
            
            VStack(alignment: .leading) {
                Text(project.po)
                    .font(.title)
                
                HStack {
                    Text(project.address)
                        .font(.subheadline)
                    Spacer()
                    Text(project.contractor)
                        .font(.subheadline)
                }
                .font(.subheadline)
                .foregroundColor(.secondary)
                
                Divider()
                
//                Text("About \(project.po)")
//                    .font(.title2)
                Text("Permit # \(project.permit)")
                Spacer()
                Text(project.description)
            }
            .padding()
        }
//        .navigationTitle(project.name)
        .navigationBarTitleDisplayMode(.inline)
    }
}

//struct SelectedProjectView_Previews: PreviewProvider {
//    static var previews: some View {
//        SelectedProjectView(project: Project)
//    }
//}
