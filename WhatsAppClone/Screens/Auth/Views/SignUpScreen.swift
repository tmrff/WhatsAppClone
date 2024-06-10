//
//  SignUpScreen.swift
//  WhatsAppClone
//
//  Created by Thomas on 10/06/24.
//

import SwiftUI

struct SignUpScreen: View {
    
    @Environment(\.dismiss) private var dismiss
    @ObservedObject var authScreenViewModel: AuthScreenViewModel
    
    var body: some View {
        VStack {
           Spacer()
            AuthHeaderView()
            AuthTextField(type: .email, text: $authScreenViewModel.email)
            
            let usernameType = AuthTextField.InputType.custom("Username", "at")
            
            AuthTextField(type: usernameType, text: $authScreenViewModel.username)
            
            AuthTextField(type: .password, text: $authScreenViewModel.password)
            
            AuthButton(title: "Create an Account") {
                Task { await authScreenViewModel.handleSignUp() }
            }
            .disabled(authScreenViewModel.disableSignUpButton)
            
            Spacer()
            
            backButton()
                .padding(.bottom, 30)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background {
            LinearGradient(colors: [.green, .green.opacity(0.8), .teal], startPoint: .top, endPoint: .bottom)
        }
        .ignoresSafeArea()
        .navigationBarBackButtonHidden()
    }
    
    private func backButton() -> some View {
        Button {
           dismiss()
        } label: {
            HStack {
                Image(systemName: "sparkles")
                
                (
                Text("Already created an account ? ")
                +
                Text("Log in").bold()
                )
                Image(systemName: "sparkles")
            }
            .foregroundStyle(.white)
        }
    }
}

#Preview {
    SignUpScreen(authScreenViewModel: AuthScreenViewModel())
}
