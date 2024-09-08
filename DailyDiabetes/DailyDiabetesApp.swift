//
//  DailyDiabetesApp.swift
//  DailyDiabetes
//
//  Created by Vlady Todorchuk on 08.09.2024.
//

import SwiftUI

@main
struct DailyDiabetesApp: App {
    @State private var authViewModel = AuthViewModel()
    
    var body: some Scene {
        WindowGroup {
            if authViewModel.isLoggedIn {
                ContentView()
                    .environment(\.authViewModel, authViewModel)
            } else {
                LoginView()
                    .environment(\.authViewModel, authViewModel)
            }
        }
    }
}
