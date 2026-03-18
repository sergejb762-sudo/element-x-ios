//
// Copyright 2025 Element Creations Ltd.
//
// SPDX-License-Identifier: AGPL-3.0-only OR LicenseRef-Element-Commercial.
// Please see LICENSE files in the repository root for full details.
//

import Compound
import SwiftUI

/// A simple placeholder coordinator used for Flox tabs that haven't been implemented yet (Contacts, Calls, Settings).
class FloxPlaceholderTabCoordinator: CoordinatorProtocol {
    let title: String
    let icon: KeyPath<CompoundIcons, Image>

    init(title: String, icon: KeyPath<CompoundIcons, Image>) {
        self.title = title
        self.icon = icon
    }

    func toPresentable() -> AnyView {
        AnyView(FloxPlaceholderTabScreen(title: title, icon: icon))
    }
}

/// A placeholder screen showing a title and icon, used for tabs not yet implemented.
private struct FloxPlaceholderTabScreen: View {
    let title: String
    let icon: KeyPath<CompoundIcons, Image>

    var body: some View {
        NavigationStack {
            VStack(spacing: 16) {
                CompoundIcon(icon, size: .custom(48), relativeTo: .compound.headingXL)
                    .foregroundStyle(.compound.iconSecondary)
                Text(title)
                    .font(.compound.headingMD)
                    .foregroundStyle(.compound.textPrimary)
                Text("Coming soon")
                    .font(.compound.bodyMD)
                    .foregroundStyle(.compound.textSecondary)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color.compound.bgCanvasDefault.ignoresSafeArea())
            .navigationTitle(title)
        }
    }
}
