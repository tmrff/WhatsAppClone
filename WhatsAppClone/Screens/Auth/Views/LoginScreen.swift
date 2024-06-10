//
//  LoginScreen.swift
//  WhatsAppClone
//
//  Created by Thomas on 9/06/24.
//

import SwiftUI

struct LoginScreen: View {
    @StateObject private var authScreenViewModel = AuthScreenViewModel()
    
    var body: some View {
        NavigationStack {
            VStack {
                Spacer()
                AuthHeaderView()
                
                AuthTextField(type: .email, text: $authScreenViewModel.email)
                AuthTextField(type: .password, text: $authScreenViewModel.password)
                
                forgotPasswordButton()
                
                AuthButton(title: "Log in now") {
                    
                }
                .disabled(authScreenViewModel.disableLoginButton)
                
                Spacer()
                
                signUpButton()
                    .padding(.bottom, 30)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color.teal.gradient)
            .ignoresSafeArea()
            .alert(isPresented: $authScreenViewModel.errorState.showError) {
                Alert(
                    title: Text(authScreenViewModel.errorState.errorMessage),
                    dismissButton: .default(Text("Ok"))
                )
            }
        }
    }
    
    private func forgotPasswordButton() -> some View {
        Button {
            
        } label: {
            Text("Forgot Password ?")
                .foregroundStyle(.white)
                .frame(maxWidth: .infinity, alignment: .trailing)
                .padding(.trailing, 32)
                .bold()
                .padding(.vertical)
        }
    }
    
    private func signUpButton() -> some View {
        NavigationLink {
            SignUpScreen(authScreenViewModel: authScreenViewModel)
        } label: {
            HStack {
                Image(systemName: "sparkles")
                
                (
                Text("Don't have an account ? ")
                +
                Text("Create one").bold()
                )
                Image(systemName: "sparkles")
            }
            .foregroundStyle(.white)
        }
    }
}

#Preview {
    LoginScreen()
}
