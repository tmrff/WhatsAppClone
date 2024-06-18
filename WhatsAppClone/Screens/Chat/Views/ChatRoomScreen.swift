//
//  ChatRoomScreen.swift
//  WhatsAppClone
//
//  Created by Thomas on 8/06/24.
//

import SwiftUI
import PhotosUI

struct ChatRoomScreen: View {
    let channel: ChannelItem
    @StateObject private var viewModel: ChatRoomViewModel
    
    init(channel: ChannelItem) {
        self.channel = channel
        _viewModel = StateObject(wrappedValue: ChatRoomViewModel(channel))
    }
    
    var body: some View {
        MessageListView(viewModel: viewModel)
        .toolbar(.hidden, for: .tabBar)
        .toolbar {
            leadingNavItem()
            trailingNavItem()
        }
        .photosPicker(
            isPresented: $viewModel.showPhotoPicker,
            selection: $viewModel.photoPickerItems,
            maxSelectionCount: 6
        )
        .navigationBarTitleDisplayMode(.inline)
        .safeAreaInset(edge: .bottom) {
            bottomSafeAreaView()
        }
    }
    
    private func bottomSafeAreaView() -> some View {
        VStack(spacing: 0) {
            
            Divider()
            if viewModel.showPhotoPickerPreview {
                MediaAttachmentPreview(mediaAttachments: viewModel.mediaAttachments)
                Divider()
            }
            
            TextInputArea(textMessage: $viewModel.textMessage) { action in
                viewModel.handleTextInputArea(action)
            }
        }
    }
}

// MARK: Toolbar Items
extension ChatRoomScreen {
    
    private var channelTitle: String {
        let maxChar = 20
        let trailingChars = channel.title.count > maxChar ? "..." : ""
        let title = String(channel.title.prefix(maxChar) + trailingChars)
        return title
    }
    
    @ToolbarContentBuilder
    private func leadingNavItem() -> some ToolbarContent {
        ToolbarItem(placement: .topBarLeading) {
            HStack {
                CircularProfileImageView(channel, size: .mini)
                
                Text(channelTitle)
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
