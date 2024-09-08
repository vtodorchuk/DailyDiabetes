
//
//  LoginView.swift
//  DailyDiabetes
//
//  Created by Vlady Todorchuk on 08.09.2024.
//

import SwiftUI

struct RegistrationView: View {
    @State private var email = ""
    @State private var password = ""
    @State private var confPassword = ""
    
    var body: some View {
        NavigationStack {
            regForm
            
            VStack(spacing: 20) {
                submitButton
                googleButton
                appleButton
                navigationButton
            }
        }
    }
    
    var regForm: some View {
        VStack(spacing: 20) {
            Text("Sing up")
                .bold()
                .font(.title)
 
            TextField("Email", text: $email)
            Divider()
            SecureField("Password", text: $password)
            Divider()
            SecureField("Confimation password", text: $confPassword)
            Divider()
        }
        .padding(20)
    }
    
    var submitButton: some View {
        Button {
            loginUser(email: email, password: password, confPassword: confPassword)
        } label: {
            RoundedRectangle(cornerSize: CGSize(width: 1, height: 10))
                .frame(width: UIScreen.main.bounds.width - 12, height: 35)
                .overlay {
                    Text("Submit")
                        .foregroundStyle(.white)
                }
        }
    }
    
    var navigationButton: some View {
        NavigationLink {
            LoginView()
        } label: {
            Label("I have an account", systemImage: "person.fill")
        }
        .navigationBarBackButtonHidden(true)
    }
    
    var googleButton: some View {
        Button {
            // Some action
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
            // Some action
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
    
    func loginUser(email: String, password: String, confPassword: String) {
        
    }
}

#Preview {
    RegistrationView()
}
