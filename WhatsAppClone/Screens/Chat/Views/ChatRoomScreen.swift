//
//  ChatRoomScreen.swift
//  WhatsAppClone
//
//  Created by Thomas on 8/06/24.
//

import SwiftUI

struct ChatRoomScreen: View {
    let channel: ChannelItem
    
    var body: some View {
        MessageListView()
        .toolbar(.hidden, for: .tabBar)
        .toolbar {
            leadingNavItem()
            trailingNavItem()
        }
        .navigationBarTitleDisplayMode(.inline)
        .safeAreaInset(edge: .bottom) {
            TextInputArea()
        }
    }
}

// MARK: Toolbar Items
extension ChatRoomScreen {
    @ToolbarContentBuilder
    private func leadingNavItem() -> some ToolbarContent {
        ToolbarItem(placement: .topBarLeading) {
            HStack {
                Circle()
                    .frame(width: 35, height: 30)
                
                Text(channel.title)
                    .bold()
            }
        }
    }
    
    @ToolbarContentBuilder
    private func trailingNavItem() -> some ToolbarContent {
        ToolbarItemGroup(placement: .topBarTrailing) {
            Button {
                
            } label: {
                Image(systemName: "video")
            }
            
            Button {
                
            } label: {
                Image(systemName: "phone")
            }
        }
    }
}

#Preview {
    NavigationView {
        ChatRoomScreen(channel: .placeholder)
    }
}
