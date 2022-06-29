//
//  ProjectsRowView.swift
//  AdvancedElectricalSolutions
//
//  Created by Josias Ballard on 5/19/22.
//

import SwiftUI

struct ProjectsRow: View {
    var project: Project
    
    var body: some View {
        HStack(spacing: 10) {
            //            project.image
            //                .resizable()
            //                .scaledToFit()
            //                .frame(width: 50, height: 50)
            VStack {
                
                Text(project.address)
                    .lineLimit(1)
            }
            
            Spacer()
        }
    }
}

//struct ProjectsRow_Previews: PreviewProvider {
//    static var previews: some View {
//        Group {
//            ProjectsRow(project: projects[0])
//            ProjectsRow(project: projects[1])
//        }
//        .previewLayout(.fixed(width: 300, height: 70))
//    }
//}
