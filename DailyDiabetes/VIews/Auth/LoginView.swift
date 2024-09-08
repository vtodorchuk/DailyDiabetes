//
//  LoginView.swift
//  DailyDiabetes
//
//  Created by Vlady Todorchuk on 08.09.2024.
//

import SwiftUI

struct LoginView: View {
    @Environment(\.authViewModel) private var viewModel
    
    @State private var errorMessage: [String] = [""]
    
    @State private var email = ""
    @State private var password = ""
    @State private var confPassword = ""
    
    var body: some View {
        NavigationStack {
            if !errorMessage.isEmpty {
                ForEach(errorMessage, id: \.self) { error in
                    Text(error)
                }
            }
            
            loginForm
            
            VStack(spacing: 20) {
                submitButton
                googleButton
                appleButton
                navigationButton
            }
        }
    }
    
    var loginForm: some View {
        VStack(spacing: 20) {
            Text("Sing in")
                .bold()
                .font(.title)
            
            TextField("Email", text: $email)
                .autocorrectionDisabled(true)
                .textInputAutocapitalization(.never)
            Divider()
            SecureField("Password", text: $password)
            Divider()
        }
        .padding(20)
    }
    
    var submitButton: some View {
        Button {
            loginUser(email: email, password: password)
        } label: {
            RoundedRectangle(cornerSize: CGSize(width: 1, height: 10))
                .frame(width: UIScreen.main.bounds.width - 12, height: 35)
                .overlay {
                    Text("Submit")
                        .foregroundStyle(.white)
                }
            
        }
        .disabled(allowSubmit())
    }
    
    var navigationButton: some View {
        NavigationLink {
            RegistrationView()
        } label: {
            Label("I dont have an account", systemImage: "person.fill")
        }
        .navigationBarBackButtonHidden(true)
    }
    
    var googleButton: some View {
        Button {
            loginUser(email: email, password: password)
        } label: {
            RoundedRectangle(cornerSize: CGSize(width: 1, height: 10))
                .frame(width: UIScreen.main.bounds.width - 12, height: 35)
                .overlay {
                    HStack {
                        Image("google")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 24, height: 24)
                        Text("Continue with Google")
                            .foregroundStyle(.black)
                    }
                }
                .foregroundStyle(.white)
                .shadow(radius: 5)
            
        }
    }
    
    var appleButton: some View {
        Button {
            loginUser(email: email, password: password)
        } label: {
            RoundedRectangle(cornerSize: CGSize(width: 1, height: 10))
                .frame(width: UIScreen.main.bounds.width - 12, height: 35)
                .overlay {
                    HStack {
                        Image(systemName: "apple.logo")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 24, height: 24)
                            .foregroundStyle(.white)
                        Text("Continue with Apple")
                            .foregroundStyle(.white)
                    }
                }
                .foregroundStyle(.black)
                .shadow(radius: 5)
            
        }
    }
    
    func loginUser(email: String, password: String) {
        viewModel.loginUser(email: email, password: password) { result in
            DispatchQueue.main.async {
                self.errorMessage = result
            }
        }
    }
    
    func allowSubmit() -> Bool {
        return email == "" || password == ""
    }
}

#Preview {
    LoginView()
        .environment(\.authViewModel, AuthViewModel())
}
