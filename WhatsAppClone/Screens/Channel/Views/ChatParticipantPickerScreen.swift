//
//  ChatParticipantPickerScreen.swift
//  WhatsAppClone
//
//  Created by Thomas on 10/06/24.
//

import SwiftUI

struct ChatParticipantPickerScreen: View {
    @State private var searchText = ""
    @Environment(\.dismiss) private var dismiss
    @StateObject private var viewModel = ChatParticipantPickerViewModel()
    
    var onCreate: (_ newChannel: ChannelItem) -> Void
    
    var body: some View {
        NavigationStack(path: $viewModel.navStack) {
            List {
                ForEach(ChatParticipantPickerOption.allCases) { item in
                    HeaderItemView(item: item) {
                        guard item == .newGroup else { return }
                        viewModel.navStack.append(.groupParticipantPicker)
                    }
                }
                
                Section {
                    ForEach(viewModel.users) { user in
                        ChatParticipantRowView(user: user)
                            .onTapGesture {
                                viewModel.selectedChatParticipants.append(user)
                                let createChannel = viewModel.createChannel(nil)
                                switch createChannel {
                                case .success(let channelItem):
                                   onCreate(channelItem)
                                    
                                case .failure(let error):
                                    print("failed to create channel: \(error.localizedDescription)")
                                }
                            }
                    }
                } header: {
                    Text("Contacts on WhatsApp")
                        .textCase(nil)
                        .bold()
                }
                
                if viewModel.isPaginatable {
                    loadMoreUsersView()
                }
            }
            .searchable(text: $searchText,
                        placement: .navigationBarDrawer(displayMode: .always),
                        prompt: "Search name or number"
            )
            .navigationTitle("New Chat")
            .navigationDestination(for: ChannelCreationRoute.self) { route in
               destinationView(for: route)
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
               trailingNavItem()
            }
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

extension ChatParticipantPickerScreen {
    @ViewBuilder
    private func destinationView(for route: ChannelCreationRoute) -> some View {
        switch route {
        case .groupParticipantPicker:
            GroupParticipantPickerScreen(viewModel: viewModel)
        case .setUpGroupChat:
            NewGroupSetUpScreen(viewModel: viewModel)
        }
    }
}

extension ChatParticipantPickerScreen {
    @ToolbarContentBuilder
    private func trailingNavItem() -> some ToolbarContent {
        ToolbarItem(placement: .topBarTrailing) {
            cancelButton()
        }
    }
    
    private func cancelButton() -> some View {
        Button {
            dismiss()
        } label: {
            Image(systemName: "xmark")
                .font(.footnote)
                .bold()
                .foregroundStyle(.gray)
                .padding(8)
                .background(Color(.systemGray5))
                .clipShape(Circle())
        }
    }
}

extension ChatParticipantPickerScreen {
    
    private struct HeaderItemView: View {
        let item: ChatParticipantPickerOption
        let onTapHander: () -> Void
        
        var body: some View {
            Button {
                onTapHander()
            } label: {
                buttonBody()
            }
        }
        
        private func buttonBody() -> some View {
            HStack {
                Image(systemName: item.imageName)
                    .font(.footnote)
                    .frame(width: 40, height: 40)
                    .background(Color(.systemGray6))
                    .clipShape(Circle())
                
                Text(item.title)
            }
        }
    }
}

enum ChatParticipantPickerOption: String, CaseIterable, Identifiable {
    case newGroup = "New Group"
    case newContact = "New Contact"
    case newCommunity = "New Community"
    
    var id: String {
        return rawValue
    }
    
    var title: String {
        return rawValue
    }
    
    var imageName: String {
        switch self {
        case .newGroup:
            return "person.2.fill"
        case .newContact:
            return "person.fill.badge.plus"
        case .newCommunity:
            return "person.3.fill"
        }
    }
}

#Preview {
    ChatParticipantPickerScreen { channel in
        
    }
}
