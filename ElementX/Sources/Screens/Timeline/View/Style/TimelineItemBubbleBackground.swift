//
// Copyright 2025 Element Creations Ltd.
// Copyright 2024-2025 New Vector Ltd.
//
// SPDX-License-Identifier: AGPL-3.0-only OR LicenseRef-Element-Commercial.
// Please see LICENSE files in the repository root for full details.
//

import Compound
import SwiftUI

extension View {
    /// - Parameters:
    ///   - isOutgoing: rounds the corners according to the side it shows on, defaults to true
    ///   - insets: defaults to what we use for file timeline items, text uses custom values
    ///   - color: self explanatory, defaults to subtle secondary
    func bubbleBackground(isOutgoing: Bool = true,
                          insets: EdgeInsets = .init(top: 8, leading: 12, bottom: 8, trailing: 12),
                          color: @autoclosure @MainActor () -> Color? = .compound.bgSubtleSecondary) -> some View {
        modifier(TimelineItemBubbleBackgroundModifier(isOutgoing: isOutgoing,
                                                      insets: insets,
                                                      color: color()))
    }
}

private struct TimelineItemBubbleBackgroundModifier: ViewModifier {
    @Environment(\.timelineGroupStyle) private var timelineGroupStyle
    
    let isOutgoing: Bool
    let insets: EdgeInsets
    var color: Color?
    
    // Flox: Telegram-style larger corner radius
    private let cornerRadius: CGFloat = 18
    private let tailCornerRadius: CGFloat = 4
    
    private var showTail: Bool {
        timelineGroupStyle == .single || timelineGroupStyle == .last
    }
    
    func body(content: Content) -> some View {
        content
            .padding(insets)
            .background(color)
            .cornerRadius(cornerRadius, corners: roundedCorners)
            .overlay(alignment: isOutgoing ? .bottomTrailing : .bottomLeading) {
                // Flox: Telegram-style tail on last/single messages
                if showTail, let color {
                    BubbleTailShape(isOutgoing: isOutgoing)
                        .fill(color)
                        .frame(width: 10, height: 16)
                        .offset(x: isOutgoing ? 6 : -6, y: -1)
                }
            }
    }
    
    private var roundedCorners: UIRectCorner {
        // Flox: Telegram-style corner rounding
        switch timelineGroupStyle {
        case .single:
            if isOutgoing {
                return [.topLeft, .topRight, .bottomLeft]
            } else {
                return [.topLeft, .topRight, .bottomRight]
            }
        case .first:
            return [.topLeft, .topRight, .bottomLeft, .bottomRight]
        case .middle:
            return .allCorners
        case .last:
            if isOutgoing {
                return [.topLeft, .topRight, .bottomLeft]
            } else {
                return [.topLeft, .topRight, .bottomRight]
            }
        }
    }
}

/// A small triangular tail shape for message bubbles (Telegram-style).
private struct BubbleTailShape: Shape {
    let isOutgoing: Bool
    
    func path(in rect: CGRect) -> Path {
        var path = Path()
        if isOutgoing {
            // Tail pointing bottom-right
            path.move(to: CGPoint(x: 0, y: 0))
            path.addLine(to: CGPoint(x: rect.width, y: rect.height * 0.7))
            path.addQuadCurve(to: CGPoint(x: rect.width * 0.3, y: rect.height),
                              control: CGPoint(x: rect.width, y: rect.height))
            path.addLine(to: CGPoint(x: 0, y: rect.height))
            path.closeSubpath()
        } else {
            // Tail pointing bottom-left
            path.move(to: CGPoint(x: rect.width, y: 0))
            path.addLine(to: CGPoint(x: 0, y: rect.height * 0.7))
            path.addQuadCurve(to: CGPoint(x: rect.width * 0.7, y: rect.height),
                              control: CGPoint(x: 0, y: rect.height))
            path.addLine(to: CGPoint(x: rect.width, y: rect.height))
            path.closeSubpath()
        }
        return path
    }
}

private extension EdgeInsets {
    init(around: CGFloat) {
        self.init(top: around, leading: around, bottom: around, trailing: around)
    }

    static var zero: Self = .init(around: 0)
}
