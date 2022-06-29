//
//  WeatherView.swift
//  AdvancedElectricalSolutions
//
//  Created by Josias Ballard on 3/2/22.
//

import SwiftUI

struct WeatherView: View {
    
    var weather: ResponseBody
    
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        NavigationView {
            
            ZStack {
                LinearGradient(gradient: Gradient(colors: [.blue, Color("lightBlue")]),
                               startPoint: .topLeading,
                               endPoint: .bottomTrailing)
                .edgesIgnoringSafeArea(.all)
                
                VStack(spacing: 8) {
                    Text(weather.name)
                        .font(.system(size: 32, weight: .medium, design: .default))
                        .foregroundColor(.white)
                        .padding(.bottom)
                    
                    VStack {
                        Image(systemName: "cloud.sun.fill")
                            .renderingMode(.original)
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 180, height: 180)
                        
                        Text(weather.main.temp.roundDouble() + "°")
                            .font(.system(size: 70, weight: .medium))
                            .foregroundColor(.white)
                        
                        HStack {
                            Text("H:\(weather.main.tempMax.roundDouble())°")
                            font(.system(size: 30, weight: .medium))
                                .foregroundColor(.white)
                            
                            Text("L:\(weather.main.tempMin.roundDouble())°")
                                .font(.system(size: 30, weight: .medium))
                                .foregroundColor(.white)
                        }
                    }
                    
                    Spacer()
                    
                }
            }
            .toolbar {
                ToolbarItemGroup(placement: .navigationBarLeading) {
                    Button {
                        presentationMode.wrappedValue.dismiss()
                    } label: {
                        Text("Cancel")
                            .foregroundColor(.white)
                    }
                }
            }
            
        }
        
        
    }
}

//struct WeatherView_Previews: PreviewProvider {
//    static var previews: some View {
//        WeatherView(weather: previewWeather)
//    }
//}

struct WeatherDayView: View {
    
    var dayOfWeek: String
    var imageName: String
    var temperature: Int
    
    var body: some View {
        VStack {
            Text(dayOfWeek)
                .font(.system(size: 16, weight: .medium, design: .default))
                .foregroundColor(.white)
            
            Image(systemName: imageName)
                .renderingMode(.original)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 40, height: 40)
            
            Text("\(temperature)°")
                .font(.system(size: 28, weight: .medium))
                .foregroundColor(.white)
        }
    }
}
