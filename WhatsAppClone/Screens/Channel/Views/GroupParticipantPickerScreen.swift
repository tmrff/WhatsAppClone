//
//  GroupParticipantPickerScreen.swift
//  WhatsAppClone
//
//  Created by Thomas on 10/06/24.
//

import SwiftUI

struct GroupParticipantPickerScreen: View {
    @ObservedObject var viewModel: ChatParticipantPickerViewModel
    @State private var searchText = ""
    var body: some View {
        List {
            
            if viewModel.showSelectedUsers {
                SelectedChatParticipantView(users: viewModel.selectedChatParticipants) { user in
                    viewModel.handleItemSelection(user)
                }
            }
            Section {
                ForEach(viewModel.users) { item in
                    Button {
                        viewModel.handleItemSelection(item)
                    } label: {
                        chatParticipantRowView(item)
                    }
                }
            }
            
            if viewModel.isPaginatable {
                loadMoreUsersView()
            }
        }
        .animation(.easeInOut, value: viewModel.showSelectedUsers)
        .searchable(text: $searchText,
                    placement: .navigationBarDrawer(displayMode: .always),
                    prompt: "Search name or number"
        )
        .toolbar {
            titleView()
            trailingNavItem()
        }
    }
    
    private func chatParticipantRowView(_ user: UserItem) -> some View {
        ChatParticipantRowView(user: user) {
           Spacer()
            let isSelected = viewModel.isUserSelected(user)
            let imageName = isSelected ? "checkmark.circle.fill" : "circle"
            let foregroundStyle = isSelected ? Color.blue : Color(.systemGray4)
            Image(systemName: imageName)
                .foregroundStyle(foregroundStyle)
                .imageScale(.large)
        }
    }
    
    private func loadMoreUsersView() -> some View {
        ProgressView()
            .frame(maxWidth: .infinity)
            .listRowBackground(Color.clear)
            .task {
                await viewModel.fetchUsers()
            }
    }
}

extension GroupParticipantPickerScreen {
    @ToolbarContentBuilder
    private func titleView() -> some ToolbarContent {
        ToolbarItem(placement: .principal) {
            VStack {
                Text("Add Participants")
                    .bold()
                
                let count = viewModel.selectedChatParticipants.count
                let maxCount = ChannelConstants.maxGroupParticipants
                
                Text("\(count) / \(maxCount)")
                    .foregroundStyle(.gray)
                    .font(.footnote)
            }
        }
    }
    
    @ToolbarContentBuilder
    private func trailingNavItem() -> some ToolbarContent {
        ToolbarItem(placement: .topBarTrailing) {
            Button("Next") {
                viewModel.navStack.append(.setUpGroupChat)
            }
            .bold()
            .disabled(viewModel.disableNextButton)
        }
    }
}

#Preview {
    NavigationStack {
        GroupParticipantPickerScreen(viewModel: ChatParticipantPickerViewModel())
    }
}
