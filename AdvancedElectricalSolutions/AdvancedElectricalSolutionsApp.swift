//
//  AdvancedElectricalSolutionsApp.swift
//  AdvancedElectricalSolutions
//
//  Created by Josias Ballard on 2/10/22.
//

import SwiftUI
import Firebase

@main
struct AdvancedElectricalSolutionsApp: App {
    var body: some Scene {
        WindowGroup {
            let viewModel = AppViewModel()
            ContentView()
                .environmentObject(viewModel)
        }
    }
}
