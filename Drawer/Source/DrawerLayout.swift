//
//  DrawerLayout.swift
//  Drawer
//
//  Created by Tre'Ellis Cooper on 6/15/24.
//

import SwiftUI

/// A structure that encapsulates drawer layout logic and behavior.
///
/// A `DrawerLayout` determines the position, size, and visual state of the
/// drawer content and drawer panel based on the provided ``DrawerPosition``.
///
/// The ``Drawer`` uses an instance of this structure to compute the visual
/// traits of its view. Its purpose is to isolate view cacluations/behavior and
/// be testable in a vacuum. See `DrawerLayoutTests`.
struct DrawerLayout: Buildable {
    let ratio: Binding<CGFloat>
    let detent: Binding<Detent>
    
    var allDetents: Set<Detent> = []
    var interactiveDetents: Set<Detent> = []
    var position: DrawerPosition = .bottom
    
    private let panelScalar: CGFloat = 1.6
    private let validDetents = Detent.all
    
    /// A method to compute the visual traits of a drawer given the current
    /// geometry (available space). The visual traits are relative to the
    /// current ``DrawerLayout/position``.
    ///
    /// - parameter geometry: The current container geometry.
    /// - returns: A trait object whose values define the visual state.
    func traits(for geometry: CGSize) -> Traits {
        switch position {
        case .bottom:
            let height = geometry.height
            let panelHeight = height.scaled(by: panelScalar)
            let offset = height - (height * ratio.wrappedValue)
            let disabled = !interactiveDetents
                .contains(detent.wrappedValue)
            
            return Traits()
                .set(\.contentAlignment, to: .top)
                .set(\.contentSize.height, to: height)
                .set(\.isContentDisabled, to: disabled)
                .set(\.panelSize.height, to: panelHeight)
                .set(\.panelOffset.y, to: offset)
                .set(\.onDrag, to: { onDrag($0.height / height) })
                .set(\.onDragEnd, to: { onDragEnd($0.height / height) })
        case .leading:
            let width = geometry.width
            let panelWidth = width.scaled(by: panelScalar)
            let offset = (width * ratio.wrappedValue) - panelWidth
            let disabled = !interactiveDetents
                .contains(detent.wrappedValue)
            
            return Traits()
                .set(\.contentAlignment, to: .trailing)
                .set(\.contentSize.width, to: width)
                .set(\.isContentDisabled, to: disabled)
                .set(\.panelSize.width, to: panelWidth)
                .set(\.panelOffset.x, to: offset)
                .set(\.onDrag, to: { onDrag(-$0.width / width) })
                .set(\.onDragEnd, to: { onDragEnd(-$0.width / width) })
        case .top:
            let height = geometry.height
            let panelHeight = height.scaled(by: panelScalar)
            let offset = (height * ratio.wrappedValue) - panelHeight
            let disabled = !interactiveDetents
                .contains(detent.wrappedValue)
            
            return Traits()
                .set(\.contentAlignment, to: .bottom)
                .set(\.contentSize.height, to: height)
                .set(\.isContentDisabled, to: disabled)
                .set(\.panelSize.height, to: panelHeight)
                .set(\.panelOffset.y, to: offset)
                .set(\.onDrag, to: { onDrag(-$0.height / height) })
                .set(\.onDragEnd, to: { onDragEnd(-$0.height / height) })
        case .trailing:
            let width = geometry.width
            let panelWidth = width.scaled(by: panelScalar)
            let offset = width - (width * ratio.wrappedValue)
            let disabled = !interactiveDetents
                .contains(detent.wrappedValue)
            
            return Traits()
                .set(\.contentAlignment, to: .leading)
                .set(\.contentSize.width, to: width)
                .set(\.isContentDisabled, to: disabled)
                .set(\.panelSize.width, to: panelWidth)
                .set(\.panelOffset.x, to: offset)
                .set(\.onDrag, to: { onDrag($0.width / width) })
                .set(\.onDragEnd, to: { onDragEnd($0.width / width) })
        }
    }
    
    // MARK: - DrawerLayout.Traits
    /// An object representing the visual/behavioral traits of a ``Drawer``.
    struct Traits: Buildable {
        var contentAlignment: Alignment = .bottom
        var contentSize: ProposedViewSize = .unspecified
        var isContentDisabled = false
        var panelOffset: CGPoint = .zero
        var panelSize: ProposedViewSize = .unspecified
        
        var onDrag: (CGSize) -> Void = { _ in }
        var onDragEnd: (CGSize) -> Void = { _ in }
    }
}

// MARK: - Helper Functions/Behavior
extension DrawerLayout {
    private func animateToDetent(_ detent: Detent) {
        withAnimation(.snappy(extraBounce: 0.1)) {
            ratio.wrappedValue = detent.value
        }
    }
    
    private func dampenRatio(
        _ ratio: CGFloat,
        to detents: ClosedRange<Detent>
    ) -> CGFloat {
        if ratio > detents.upperBound.value {
            return 0.2 * log(ratio - (detents.upperBound.value - 1))
              + detents.upperBound.value
        } else if ratio < detents.lowerBound.value {
            return -0.2 * log(-ratio + (detents.lowerBound.value + 1))
              + detents.lowerBound.value
        } else {
            return ratio
        }
    }
    
    private func onDrag(_ delta: CGFloat) {
        let adjusted = detent.wrappedValue.value - delta
        let damped = dampenRatio(adjusted, to: validDetents)

        ratio.wrappedValue = damped
    }
    
    private func onDragEnd(_ delta: CGFloat) {
        let adjusted = detent.wrappedValue.value - delta
        let nearest = nearestDetent(for: adjusted)

        detent.wrappedValue = nearest
        animateToDetent(nearest)
    }

    private func nearestDetent(for ratio: CGFloat) -> Detent {
        let predicate: (Detent, Detent) -> Bool = {
            abs($0.value - ratio) < abs($1.value - ratio)
        }

        let match = allDetents.sorted(by: predicate).first
        let nearest = match ?? .init(floatLiteral: ratio)

        return nearest
    }
}
