//
//  CardView.swift
//  AdvancedElectricalSolutions
//
//  Created by Josias Ballard on 3/1/22.
//

import SwiftUI


struct CardView: View {
    
    var titleText: String
    var subtitleText: String
    var image: String
    
    var body: some View {
        
        VStack(alignment: .leading) {
            
            Text(titleText)
                .font(.title3)
                .foregroundColor(.primary)
            
            Text(subtitleText)
                .font(.subheadline)
                .foregroundColor(.secondary)
            
            Image(image)
                .resizable()
                .frame(height: 200, alignment: .center)
                .cornerRadius(5)
            
        }
        .frame(minWidth: 0, maxWidth: .infinity, alignment: .leading)
        .padding()
        
    }
}

struct CardView_Previews: PreviewProvider {
    static var previews: some View {
        CardView(titleText: "Weather", subtitleText: "What's the weather like this week?", image: "weather")
    }
}
