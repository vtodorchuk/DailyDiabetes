//
//  ContentView.swift
//  DailyDiabetes
//
//  Created by Vlady Todorchuk on 08.09.2024.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        VStack {
            TabView {
                Text("List")
                    .tabItem {
                        Label("List", systemImage: "list.bullet.clipboard.fill")
                    }
                AccountView()
                    .tabItem {
                        Label("Account", systemImage: "person.fill")
                    }
                    .badge(1)
                Text("Settings")
                    .tabItem {
                        Label("Settings", systemImage: "gearshape.fill")
                    }
            }
        }
    }
}

#Preview {
    ContentView()
}
