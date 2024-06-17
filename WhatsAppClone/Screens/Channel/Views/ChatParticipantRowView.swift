//
//  ChatParticipantRowView.swift
//  WhatsAppClone
//
//  Created by Thomas on 10/06/24.
//

import SwiftUI

struct ChatParticipantRowView<Content: View>: View {
    private let user: UserItem
    private let trailingItems: Content
    
    init(user: UserItem, @ViewBuilder trailingItems: () -> Content = { EmptyView() }) {
        self.user = user
        self.trailingItems = trailingItems()
    }
    
    var body: some View {
        HStack {
            CircularProfileImageView(user.profileImageURL, size: .xSmall)
                
            VStack(alignment: .leading) {
                Text(user.username)
                    .bold()
                    .foregroundStyle(.whatsAppBlack)
                
                Text(user.bioUnwrapped)
                    .font(.caption)
                    .foregroundStyle(.gray)
            }
            
            trailingItems
        }
    }
}

#Preview {
    ChatParticipantRowView(user: .placeholder)
}
