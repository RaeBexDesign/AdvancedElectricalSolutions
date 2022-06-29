//
//  ScheduleView.swift
//  AdvancedElectricalSolutions
//
//  Created by Josias Ballard on 3/2/22.
//

import SwiftUI

struct ScheduleView: View {
    
    @Environment(\.presentationMode) var presentationMode
    
    @State var currentDate: Date = Date()
    
    var body: some View {
        NavigationView {
            
            ScrollView(.vertical, showsIndicators: false) {
                
                VStack(spacing: 20) {
                    
                    //Custom date picker...
                    CustomDatePicker(currentDate: $currentDate)
                }
                .padding(.vertical)
            }
            .toolbar {
                ToolbarItemGroup(placement: .navigationBarLeading) {
                    Button {
                        presentationMode.wrappedValue.dismiss()
                    } label: {
                        Text("Cancel")
                    }
                }
            }
            //Safe area View...
            .safeAreaInset(edge: .bottom) {
                
                HStack {
                    
                    Button {
                        
                    } label: {
                        Text("Add Task")
                            .fontWeight(.bold)
                            .padding(.vertical)
                            .frame(maxWidth: .infinity)
                            .background(Color("Blue"), in: Capsule())
                    }
                    
                    Button {
                        
                    } label: {
                        Text("Add Reminder")
                            .fontWeight(.bold)
                            .padding(.vertical)
                            .frame(maxWidth: .infinity)
                            .background(Color("Blue"), in: Capsule())
                    }
                    
                }
                .padding(.horizontal)
                .padding(.top, 10)
                .foregroundColor(.white)
                .background(.ultraThinMaterial)
                
            }
        }
    }
}

struct ScheduleView_Previews: PreviewProvider {
    static var previews: some View {
        ScheduleView()
    }
}
