//
//  AccountView.swift
//  DailyDiabetes
//
//  Created by Vlady Todorchuk on 08.09.2024.
//

import SwiftUI

struct AccountView: View {
    @Environment(\.authViewModel) private var viewModel
    @State private var errorMessage = [""]
    
    var body: some View {
        Button("Logout") {
            deleteToken()
        }
        .foregroundStyle(.red)
    }
    
    func deleteToken() {
        viewModel.logoutUser()  { result in
            DispatchQueue.main.async {
                self.errorMessage = result
            }
        }
    }
}

#Preview {
    AccountView()
        .environment(\.authViewModel, AuthViewModel())
}
