//
//  AuthScreenViewModel.swift
//  WhatsAppClone
//
//  Created by Thomas on 10/06/24.
//

import Foundation

final class AuthScreenViewModel: ObservableObject {
    
    // MARK: Published Properties
    
    @Published var isLoading = false
    @Published var email = ""
    @Published var password = ""
    @Published var username = ""
    
    // MARK: Computed Properties
    var disableLoginButton: Bool {
        return email.isEmpty || password.isEmpty || isLoading
    }
    
    var disableSignUpButton: Bool {
        return email.isEmpty || password.isEmpty || username.isEmpty || isLoading
    }
}
