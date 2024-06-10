//
//  RootScreen.swift
//  WhatsAppClone
//
//  Created by Thomas on 10/06/24.
//

import SwiftUI

struct RootScreen: View {
    
    @StateObject private var viewModel = RootScreenViewModel()
    
    var body: some View {
        switch viewModel.authState {
        case .pending:
            ProgressView()
                .controlSize(.large)
            
        case .loggedIn(let loggedInUser):
            MainTabView()
            
        case .loggedOut:
            LoginScreen()
        }
    }
}

#Preview {
    RootScreen()
}
