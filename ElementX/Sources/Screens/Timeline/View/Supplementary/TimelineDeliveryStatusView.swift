//
// Copyright 2025 Element Creations Ltd.
// Copyright 2022-2025 New Vector Ltd.
//
// SPDX-License-Identifier: AGPL-3.0-only OR LicenseRef-Element-Commercial.
// Please see LICENSE files in the repository root for full details.
//

import Compound
import SwiftUI

struct TimelineDeliveryStatusView: View {
    enum Status {
        case sending
        case sent
    }

    let deliveryStatus: Status
    
    var body: some View {
        // Flox: Telegram-style checkmarks
        switch deliveryStatus {
        case .sending:
            Image(systemName: "checkmark")
                .font(.system(size: 11, weight: .bold))
                .foregroundColor(.compound.iconSecondary)
                .accessibilityLabel(L10n.commonSending)
        case .sent:
            // Double checkmark like Telegram "delivered/read"
            Image(systemName: "checkmark")
                .font(.system(size: 11, weight: .bold))
                .foregroundColor(.compound.iconAccentTertiary)
                .overlay(alignment: .trailing) {
                    Image(systemName: "checkmark")
                        .font(.system(size: 11, weight: .bold))
                        .foregroundColor(.compound.iconAccentTertiary)
                        .offset(x: 4)
                }
                .accessibilityLabel(L10n.commonSent)
        }
    }
}

struct TimelineDeliveryStatusView_Previews: PreviewProvider, TestablePreview {
    static var previews: some View {
        VStack(spacing: 8) {
            TimelineDeliveryStatusView(deliveryStatus: .sending)
            TimelineDeliveryStatusView(deliveryStatus: .sent)
        }
    }
}
