//
//  WeatherContentView.swift
//  AdvancedElectricalSolutions
//
//  Created by Josias Ballard on 4/14/22.
//

import SwiftUI

struct WeatherContentView: View {
    
    @StateObject var locationManager = LocationManager()
    var weatherManager = WeatherManager()
    @State var weather: ResponseBody?
    
    var body: some View {
        
        ZStack {
            
            LinearGradient(gradient: Gradient(colors: [.blue, Color("lightBlue")]),
                           startPoint: .topLeading,
                           endPoint: .bottomTrailing)
            .edgesIgnoringSafeArea(.all)
            
            VStack {
                
                if let location = locationManager.location {
                    if let weather = weather {
                        WeatherView(weather: weather)
                    } else {
                        LoadingView()
                            .task {
                                do {
                                    weather = try await weatherManager.getCurrentWeather(latitude: location.latitude, longitude: location.longitude)
                                } catch {
                                    print("Error getting weather: \(error)")
                                }
                            }
                    }
                } else {
                    if locationManager.isLoading {
                        LoadingView()
                    } else {
                        WelcomeView()
                            .environmentObject(locationManager)
                    }
                }
                
            }
            
        }
        
    }
}

struct WeatherContentView_Previews: PreviewProvider {
    static var previews: some View {
        WeatherContentView()
    }
}
