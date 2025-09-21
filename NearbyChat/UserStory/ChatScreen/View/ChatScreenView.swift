//
//  Created by Dmitriy Permyakov on 21.09.2025.
//  Copyright © 2025 MightyKingRichard. All rights reserved.
//

import SwiftUI

struct ChatScreenView: View {

    @State
    var state: ChatScreenViewState
    let output: ChatScreenViewModel

    var body: some View {
        ScrollViewReader { proxy in
            content
                .onChange(of: state.messages) { _, _ in
                    withAnimation {
                        proxy.scrollTo("bottom", anchor: .bottom)
                    }
                }
        }
        .safeAreaInset(edge: .bottom, spacing: .zero) {
            inputContainer
        }
    }
}

// MARK: - UI Subviews

private extension ChatScreenView {

    var content: some View {
        ScrollView {
            VStack(spacing: 10) {
                ForEach(state.messages) { message in
                    messageCell(for: message)
                }
            }
            .padding(.horizontal)

            // Якорь
            Color.clear
                .frame(height: 1)
                .id("bottom")
        }
        .onFirstAppear(perform: output.onFirstAppear)
        .onDisappear(perform: output.onDisappear)
        .scrollIndicators(.hidden)
        .scrollDismissesKeyboard(.interactively)
    }

    func messageCell(for message: ChatScreenViewState.Message) -> some View {
        Text(message.text)
            .foregroundStyle(.white)
            .padding(.vertical, 14)
            .padding(.horizontal, 20)
            .background(message.isYou ? Color.blue : .primary, in: .rect(cornerRadius: 24))
            .frame(maxWidth: .infinity, alignment: message.isYou ? .trailing : .leading)
            .padding(message.isYou ? .leading : .trailing, 30)
    }

    var inputContainer: some View {
        HStack(spacing: 8) {
            TextField("Сообщение", text: $state.inputText)
                .textFieldStyle(.roundedBorder)

            Button("Отправить") {
                output.onTapSendMessage()
            }
            .buttonBorderShape(.capsule)
            .buttonStyle(.borderedProminent)
            .tint(.black)
        }
        .padding()
    }
}
