//
//  Created by Dmitriy Permyakov on 21.09.2025.
//  Copyright © 2025 MightyKingRichard. All rights reserved.
//

import SwiftUI
import BluetoothServiceInterface

struct StartScreenView: View {

    @State
    var state: StartScreenViewState
    let output: StartScreenViewModel

    var body: some View {
        content
    }
}

// MARK: - UI Subviews

private extension StartScreenView {

    var content: some View {
        List {
            ForEach(state.peers) { item in
                cellView(item: item)
            }
        }
        .scrollIndicators(.hidden)
        .alert(state.alert.title, isPresented: $state.showAlert) {
            Button(state.alert.buttonText, action: state.alert.actionOk)
            Button("Нет", action: state.alert.actionCancel)
        } message: {
            Text(state.alert.subtitle)
        }
        .safeAreaInset(edge: .bottom, spacing: .zero) {
            buttonContainer
        }
    }

    func cellView(item: Peer) -> some View {
        Button {
            output.onTapPeerCell(with: item)
        } label: {
            HStack(spacing: .zero) {
                Text(item.peer.displayName)
                Spacer()
                Image(systemName: "chevron.right")
                    .foregroundStyle(.secondary)
            }
        }
        .foregroundStyle(.primary)
    }

    var buttonContainer: some View {
        HStack(spacing: 8) {
            Button {
                output.onTapStart()
            } label: {
                Text("Подключиться")
                    .frame(maxWidth: .infinity)
            }
            .buttonStyle(.borderedProminent)
            .tint(.blue)
            .controlSize(.extraLarge)

            Button {
                output.onTapStop()
            } label: {
                Text("Выйти")
                    .frame(maxWidth: .infinity)
            }
            .buttonStyle(.borderedProminent)
            .tint(.black)
            .controlSize(.extraLarge)
        }
        .padding()
    }
}
