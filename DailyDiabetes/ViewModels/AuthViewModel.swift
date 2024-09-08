//
//  UserViewModel.swift
//  DailyDiabetes
//
//  Created by Vlady Todorchuk on 08.09.2024.
//

import Foundation
import Observation
import SwiftUI

@Observable
class AuthViewModel {
    var isLoggedIn = KeychainManager.instance.getToken(forKey: "access_token") != nil
    
    private let backendUrl = "http://127.0.0.1:3000/api/v1"
    
    func loginUser(email: String, password: String, completion: @escaping ([String]) -> Void) {
        let parameters = ["email": email, "password": password]
        let url = URL(string: backendUrl + "/session")!
        let session = URLSession.shared
        var request = URLRequest(url: url)
        
        request.httpMethod = "POST"
        request.httpBody = try? JSONSerialization.data(withJSONObject: parameters, options: .fragmentsAllowed)
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        
        let task = session.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {
                completion(["Error"])
                return
            }
            
            if let httpResponse = response as? HTTPURLResponse {
                if httpResponse.statusCode == 200 {
                    do {
                        let response = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String: Any]
                        
                        let accessToken = response?["access"] as? String ?? ""
                        let refreshToken = response?["refresh"] as? String ?? ""
                        let csrfToken = response?["csrf"] as? String ?? ""
                        
                        try KeychainManager.instance.saveToken(accessToken, forKey: "access_token")
                        try KeychainManager.instance.saveToken(refreshToken, forKey: "refresh_token")
                        try KeychainManager.instance.saveToken(csrfToken, forKey: "csrf_token")
                        
                        self.isLoggedIn.toggle()
                        
                        print("User is authenticated. Token: \(accessToken)")
                        completion([""])
                    } catch {
                        print(error.localizedDescription)
                        completion([error.localizedDescription])
                    }
                } else {
                    do {
                        let response = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String: Any]
                        let errorMessage = response?["errors"] as? [String] ?? ["Unknown error"]
                        print(errorMessage)
                        completion(errorMessage)
                    } catch {
                        print(error.localizedDescription)
                        completion(["Error"])
                    }
                }
            }
        }
        
        task.resume()
    }
    
    func logoutUser(completion: @escaping ([String]) -> Void) {
        let url = URL(string: backendUrl + "/session")!
        let session = URLSession.shared
        var request = URLRequest(url: url)
        
        request.httpMethod = "DELETE"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        
        if let accessToken = KeychainManager.instance.getToken(forKey: "access_token") { request.setValue("Bearer \(accessToken)", forHTTPHeaderField: "Authorization") }
        
        if let csrfToken = KeychainManager.instance.getToken(forKey: "csrf_token") { request.setValue(csrfToken, forHTTPHeaderField: "X-CSRF-Token") }
        
        let task = session.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {
                completion(["Error"])
                return
            }
            
            if let httpResponse = response as? HTTPURLResponse {
                if httpResponse.statusCode == 200 {
                    do {
                        try KeychainManager.instance.deleteToken(forKey: "access_token")
                        try KeychainManager.instance.deleteToken(forKey: "refresh_token")
                        try KeychainManager.instance.deleteToken(forKey: "csrf_token")
                        
                        self.isLoggedIn.toggle()
                        
                        print("User is unauthenticated")
                        completion([""])
                    } catch {
                        print(error.localizedDescription)
                        completion([error.localizedDescription])
                    }
                } else {
                    do {
                        let response = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String: Any]
                        let errorMessage = response?["errors"] as? [String] ?? ["Unknown error"]
                        print(errorMessage)
                        completion(errorMessage)
                    } catch {
                        print(error.localizedDescription)
                        completion(["Error"])
                    }
                }
            }
        }
        
        task.resume()
        
//        try? KeychainManager.instance.deleteToken(forKey: "access_token")
//        try? KeychainManager.instance.deleteToken(forKey: "refresh_token")
//        try? KeychainManager.instance.deleteToken(forKey: "csrf_token")
//        
//        self.isLoggedIn.toggle()
    }
}


extension EnvironmentValues {
    var authViewModel: AuthViewModel {
        get { self[AuthViewModelKey.self] }
        set { self[AuthViewModelKey.self] = newValue }
    }
}

private struct AuthViewModelKey: EnvironmentKey {
    static var defaultValue: AuthViewModel = AuthViewModel()
}
